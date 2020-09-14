using System;
using System.Threading.Tasks;
using System.Windows;
using System.Net.Http;
using System.Web.Script.Serialization;
using DigitalWorkspace.ViewModels;
using System.Collections.ObjectModel;
using System.Windows.Threading;
using System.Drawing;
using System.Windows.Media.Imaging;
using System.IO;
using System.Net;
using System.Globalization;
using System.Diagnostics;
using System.Windows.Automation;
using Condition = System.Windows.Automation.Condition;
using System.Collections.Generic;
using System.Threading;
using System.Runtime.InteropServices;
using System.Text;
using DigitalWorkspace.Models;
using System.Linq;
using System.Xml;
using System.Xml.Serialization;
using System.IO.IsolatedStorage;

namespace DigitalWorkspace
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public string token;
        public int screenshot_interval;
        public string message;
        public bool IsRecodingApplist;
        public string first_name;
        public string last_name;
        public string user_id;
        public bool isClockin;
        public string userOutletId;
        public ObservableCollection<TaskRoom> tasks;
        public ObservableCollection<MeetingRoom> meetingRooms;
        ControlPanel controlPanel;
        LoginViewModel loginViewModel;
        WelcomeViewModel welcomeViewModel;
        public ClockinViewModel clockinViewModel;
        CreateViewModel createViewModel;
        DispatcherTimer dispatcherTimer;
        DispatcherTimer checkApplications;
        DispatcherTimer keepMessage;
        DispatcherTimer AutoCheck;
        DispatcherTimer RefreshMeetingTasks;
        public bool bAllowAttendance;
        public bool bAllowAddMeetingRoom;
        public bool bAllowAddTask;
        public String serverUrl;
        private List<Activity> appList;
        public string capture_directory;
        public float clockinMinutes;
        public float totalTimefromclockin;
        public MainWindow()
        {
            InitializeComponent();
            serverUrl = "https://carbonateapp.com";
            this.IsRecodingApplist = false;
            this.totalTimefromclockin = 0;
            this.Top = 100;
            this.Left = System.Windows.SystemParameters.PrimaryScreenWidth - 400;
            controlPanel = new ControlPanel(this);
            loginViewModel = new LoginViewModel(this);
            createViewModel = new CreateViewModel();
            clockinViewModel = new ClockinViewModel();
            this.tasks = new ObservableCollection<TaskRoom>();
            this.meetingRooms = new ObservableCollection<MeetingRoom>();
            DataContext = loginViewModel;
            isClockin = false;
            this.dispatcherTimer = new DispatcherTimer();
            this.checkApplications = new DispatcherTimer();
            this.AutoCheck = new DispatcherTimer();
            this.RefreshMeetingTasks = new DispatcherTimer();
            this.dispatcherTimer.Tick += dispatcherTimer_Tick;
            this.checkApplications.Tick += checkApplications_Tick;
            this.token = "";
            this.screenshot_interval = 600;
            this.dispatcherTimer.Interval = new TimeSpan(0, 10, 0);
            this.checkApplications.Interval = new TimeSpan(0, 1, 0);
            this.keepMessage = new DispatcherTimer();
            this.keepMessage.Interval = new TimeSpan(0, 0, 4);
            this.AutoCheck.Interval = new TimeSpan(0, 0, 15);
            this.RefreshMeetingTasks.Interval = new TimeSpan(0, 0, 50);
            this.keepMessage.Tick += keepMessage_Tick;
            this.bAllowAttendance = false;
            this.bAllowAddMeetingRoom = false;
            this.bAllowAddTask = false;
            this.AutoCheck.Tick += AutoCheck_TickAsync;
            this.RefreshMeetingTasks.Tick += RefreshMeetingTasks_TickAsync;
        }

        private async void appListInfoInitAsync()
        {
            this.capture_directory = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + "\\DigitalWorkspace";
            System.IO.Directory.CreateDirectory(capture_directory);
            string listInfoPath = capture_directory + "\\" + this.user_id + "_info.xml";
            Record r = DeSerializeObject<Record>(listInfoPath);
            
            if (r == null || r.applist.Count == 0)
            {
                appList = new List<Activity>();
                this.clockinMinutes = 0;
                this.totalTimefromclockin = 0;
            }
            else
            {
                this.appList = r.applist;
                float totalTimebeforeFinished = r.totalMinutes;
                float duringFromFinished = 0;
                try
                {
                    DateTime modificationDate = File.GetLastWriteTime(listInfoPath);
                    duringFromFinished = (float)DateTime.Now.Subtract(modificationDate).TotalMinutes;
                    if(duringFromFinished < 0)
                        duringFromFinished = 0;
                }
                catch(Exception e)
                {
                    Console.WriteLine(e.ToString());
                    duringFromFinished = 0;
                }
                clockinMinutes = getClockinMinutes(appList);
                if (totalTimebeforeFinished == 0)
                    totalTimebeforeFinished = clockinMinutes;
                this.totalTimefromclockin = duringFromFinished + totalTimebeforeFinished;
                if (totalTimefromclockin >= 120)
                {
					await uploadApplistInofRequest();
					//if (!isClockin)
					//    checkApplications.Stop();
					//this.totalTimefromclockin = 0;
					//File.Delete(listInfoPath);
					//appList = new List<Activity>();
					//clockinMinutes = 0;
				}                
            }
        }

        private float getClockinMinutes(List<Activity> appList)
        {
            if (appList == null) return 0;
            foreach(Activity activity in appList)
            {
                if(activity.activity_minutes > 0 && activity.activity_percentage > 0)
                {
                    return activity.activity_minutes * 100 / (activity.activity_percentage > 100 ? 100: activity.activity_percentage) ;
                }
            }
            return 0;
        }

        protected void remember(ExitEventArgs e)
        {
            try
            {

                //First get the 'user-scoped' storage information location reference in the assembly
                IsolatedStorageFile isolatedStorage = IsolatedStorageFile.GetUserStoreForAssembly();
                //create a stream writer object to write content in the location
                StreamWriter srWriter = new StreamWriter(new IsolatedStorageFileStream("data_crd", FileMode.Create, isolatedStorage));
                //check the Application property collection contains any values.
                if (App.Current.Properties[0] != null)
                {
                    //wriet to the isolated storage created in the above code section.
                    srWriter.WriteLine(App.Current.Properties[0].ToString() + " : (Stored at : " + System.DateTime.Now.ToLongTimeString() + ")");

                }

                srWriter.Flush();
                srWriter.Close();
            }
            catch (System.Security.SecurityException sx)
            {
                MessageBox.Show(sx.Message);
                throw;
            }
        }

        public void start_capture()
        {
            Console.WriteLine("Start capture");
            if (!this.dispatcherTimer.IsEnabled)
            {
                this.dispatcherTimer.Start();
            }
            if (!this.checkApplications.IsEnabled)
            {
				this.checkApplications.Start();
			}
        }
        public void stop_capture()
        {
            Console.WriteLine("Stop capture");
            this.dispatcherTimer.Stop();
            this.checkApplications.Stop();
        }
        public async void RefreshMeetingTasks_TickAsync(object sender, EventArgs e)
        {
            using (var httpClient = new HttpClient())
            {
                Console.WriteLine("refreshing task and meetings");
                string url = this.serverUrl + "/digital-workspace";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                    return;
                }
                else form.Add(new StringContent(this.token), "token");
                if (this.userOutletId == "" || this.userOutletId == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
					this.logout();
					return;
                }
                else form.Add(new StringContent(this.userOutletId), "userOutletId");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        //this.isClockin = false;
                        message = "Something went wrong. Please try again!";
                        //this.alertShow(message);
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Auth>(responseBody.Result.ToString());

                        if (JSONObj.status == 1)
                        {
                            meetingRooms = JSONObj.data.meetingRooms;
                            tasks = JSONObj.data.tasks;
                            this.bAllowAddTask = JSONObj.data.bAllowAddTask;
                            this.bAllowAddMeetingRoom = JSONObj.data.bAllowAddMeetingRoom;
                            this.clockin();
                            return;
                        }
                        else
                        {
                            message = JSONObj.data.message.ToString();
                            if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.alertShow(message);
                                this.logout();
                            }
                            //this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    //this.alertShow(message);
                    //this.logout();
                    return;
                }

            }
        }

        [DllImport("user32.dll")]
        static extern int GetWindowTextLength(IntPtr hWnd);

        [DllImport("user32.dll")]
        private static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        public void GetChromeUrl(Process process, List<Activity> currentApplist)
        {
            if (process == null)
                throw new ArgumentNullException("process");

            if (process.MainWindowHandle == IntPtr.Zero)
                return;

            AutomationElement root = AutomationElement.FromHandle(process.MainWindowHandle);
            System.Windows.Automation.Condition condNewTab = new PropertyCondition(AutomationElement.NameProperty, "New Tab");
            AutomationElement elmNewTab = root.FindFirst(TreeScope.Descendants, condNewTab);
            // get the tabstrip by getting the parent of the 'new tab' button 
            TreeWalker treewalker = TreeWalker.ControlViewWalker;
            if (elmNewTab == null) return;
            AutomationElement elmTabStrip = treewalker.GetParent(elmNewTab);
            // loop through all the tabs and get the names which is the page title 
            Condition condTabItem = new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.TabItem);
            List<Activity> details = null;
            foreach (Activity activity in currentApplist)
            {
                if (activity.name == "chrome")
                {
                    details = activity.details;
                }
            }
            if (details == null)
            {
                Activity activity = new Activity();
                activity.name = "chrome";
                details = activity.details;
                currentApplist.Add(activity);
            }
            foreach (AutomationElement tabitem in elmTabStrip.FindAll(TreeScope.Children, condTabItem))
            {
                if (tabitem == null)
                    continue;
                if (!String.IsNullOrEmpty(tabitem.Current.Name))
                {
                    bool is_new = true;
                    for (int i = 0; i < details.Count; i++)
                    {
                        if (details.ElementAt(i).name == tabitem.Current.Name)
                        {
                            is_new = false;
                            break;
                        }
                    }
                    if (is_new)
                    {
                        Activity detail = new Activity();
                        detail.name = tabitem.Current.Name;
                        detail.activity_minutes = 1;
                        details.Add(detail);
                    }
                }
            }
        }

        public void GetInternetExplorerUrl(Process process, List<Activity> currentApplist)
        {
            if (process == null)
                throw new ArgumentNullException("process");

            if (process.MainWindowHandle == IntPtr.Zero)
                return;

            AutomationElement element = AutomationElement.FromHandle(process.MainWindowHandle);
            if (element == null)
                return;

            AutomationElement rebar = element.FindFirst(TreeScope.Children, new PropertyCondition(AutomationElement.ClassNameProperty, "ReBarWindow32"));
            if (rebar == null)
                return;
            List<Activity> details = null;
            foreach (Activity activity in currentApplist)
            {
                if (activity.name == "iexplore")
                {
                    details = activity.details;
                }
            }
            if (details == null)
            {
                Activity activity = new Activity();
                activity.name = "iexplore";
                details = activity.details;
                currentApplist.Add(activity);
            }
            foreach (AutomationElement tabitem in element.FindAll(TreeScope.Subtree, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.TabItem)))
            {
                if (tabitem == null)
                    continue;
                if (!String.IsNullOrEmpty(tabitem.Current.Name))
                {
                    bool is_new = true;
                    for (int i = 0; i < details.Count; i++)
                    {
                        if (details.ElementAt(i).name == tabitem.Current.Name)
                        {
                            is_new = false;
                            break;
                        }
                    }
                    if (is_new)
                    {
                        Activity detail = new Activity();
                        detail.name = tabitem.Current.Name;
                        detail.activity_minutes = 1;
                        details.Add(detail);
                    }
                }
            }
        }

        [DllImport("user32")]
        public static extern IntPtr GetDesktopWindow();
        public void GetMicrosofEdgeUrl(Process process, List<Activity> currentApplist)
        {
            if (process == null)
                throw new ArgumentNullException("process");

            AutomationElement element = AutomationElement.FromHandle(GetDesktopWindow());
            if (element == null)
                return;

            List<Activity> details = null;
            foreach (Activity activity in currentApplist)
            {
                if (activity.name == "MicrosoftEdge")
                {
                    details = activity.details;
                }
            }
            if (details == null)
            {
                Activity activity = new Activity();
                activity.name = "MicrosoftEdge";
                details = activity.details;
                currentApplist.Add(activity);
            }
            foreach (AutomationElement child in element.FindAll(TreeScope.Children, PropertyCondition.TrueCondition))
            {
                AutomationElement window = GetEdgeCommandsWindow(child);
                if (window == null) // not edge
                    continue;
                if (!String.IsNullOrEmpty(GetEdgeTitle(child)))
                {
                    bool is_new = true;
                    for (int i = 0; i < details.Count; i++)
                    {
                        if (details.ElementAt(i).name == GetEdgeTitle(child))
                        {
                            is_new = false;
                            break;
                        }
                    }
                    if (is_new)
                    {
                        Activity detail = new Activity();
                        detail.name = GetEdgeTitle(child);
                        detail.activity_minutes = 1;
                        details.Add(detail);
                    }
                }
            }
        }

        public void GetMSEdgeUrl(Process process, List<Activity> currentApplist)
        {
            if (process == null)
                throw new ArgumentNullException("process");

            AutomationElement element = AutomationElement.FromHandle(GetDesktopWindow());
            if (element == null)
                return;

            List<Activity> details = null;
            foreach (Activity activity in currentApplist)
            {
                if (activity.name == "msedge")
                {
                    details = activity.details;
                }
            }
            if (details == null)
            {
                Activity activity = new Activity();
                activity.name = "msedge";
                details = activity.details;
                currentApplist.Add(activity);
            }
            foreach (AutomationElement child in element.FindAll(TreeScope.Children, PropertyCondition.TrueCondition))
            {
                AutomationElement pane = GetMSEdgeCommandsWindow(child);
                if (pane == null) // not edge
                    continue;
                if (!String.IsNullOrEmpty(GetEdgeTitle(child)))
                {
                    bool is_new = true;
                    for (int i = 0; i < details.Count; i++)
                    {
                        if (details.ElementAt(i).name == GetMSEdgeTitle(child))
                        {
                            is_new = false;
                            break;
                        }
                    }
                    if (is_new)
                    {
                        Activity detail = new Activity();
                        detail.name = GetEdgeTitle(child);
                        detail.activity_minutes = 1;
                        details.Add(detail);
                    }
                }
                //Console.WriteLine(tabitem.Current.Name);
            }
        }

        public static AutomationElement GetEdgeCommandsWindow(AutomationElement edgeWindow)
        {
            return edgeWindow.FindFirst(TreeScope.Children, new AndCondition(
                new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.Window),
                new PropertyCondition(AutomationElement.NameProperty, "Microsoft Edge")));
        }

        public static string GetEdgeTitle(AutomationElement edgeWindow)
        {
            var adressEditBox = edgeWindow.FindFirst(TreeScope.Children,
                new PropertyCondition(AutomationElement.AutomationIdProperty, "TitleBar"));
            return adressEditBox.Current.Name;
        }

        public static AutomationElement GetMSEdgeCommandsWindow(AutomationElement edgeWindow)
        {
            return edgeWindow.FindFirst(TreeScope.Children, new AndCondition(
                new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.Pane),
                new PropertyCondition(AutomationElement.NameProperty, "Microsoft Edge")));
        }

        public static string GetMSEdgeTitle(AutomationElement edgeWindow)
        {
            var adressEditBox = edgeWindow.FindFirst(TreeScope.Children,
                new PropertyCondition(AutomationElement.AutomationIdProperty, "Tab bar"));

            return adressEditBox.Current.Name;
        }

        public void GetFirefoxUrl(Process process, List<Activity> currentApplist)
        {
            if (process == null)
                throw new ArgumentNullException("process");

            if (process.MainWindowHandle == IntPtr.Zero)
                return;

            AutomationElement element = AutomationElement.FromHandle(process.MainWindowHandle);
            if (element == null)
                return;
            List<Activity> details = null;
            foreach(Activity activity in currentApplist)
            {
                if(activity.name == "firefox")
                {
                    details = activity.details;
                }
            }
            if(details == null)
            {
                Activity activity = new Activity();
                activity.name = "firefox";
                details = activity.details;
                currentApplist.Add(activity);
            }

            foreach(AutomationElement tabitem in element.FindAll(TreeScope.Subtree, new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.TabItem)))
            {
                if (tabitem == null)
                    continue;
                if (!String.IsNullOrEmpty(tabitem.Current.Name))
                {
                    bool is_new = true;
                    for (int i = 0; i < details.Count; i++)
                    {
                        if (details.ElementAt(i).name == tabitem.Current.Name)
                        {
                            is_new = false;
                            break;
                        }
                    }
                    if (is_new)
                    {
                        Activity detail = new Activity();
                        detail.name = tabitem.Current.Name;
                        detail.activity_minutes = 1;
                        details.Add(detail);
                    }
                }
            }

        }
        public async void checkApplist()
        {
            try
            {
                Console.WriteLine("-------------------start---------------------");
                string listInfoPath = capture_directory + "\\" + this.user_id + "_info.xml";
                List<Activity> currentApplist = new List<Activity>();
                this.totalTimefromclockin++;
                if (appList == null)
                {
                    appList = new List<Activity>();
                }
                if (isClockin)
                {

                    Process[] processes = Process.GetProcesses();

                    foreach (Process p in processes)
                    {
                        if (!String.IsNullOrEmpty(p.MainWindowTitle))
                        {
                            if (p.ProcessName == "chrome" && !IsRecodingApplist)
                            {
                                Console.WriteLine("chrome");
                                IsRecodingApplist = true;
                                GetChromeUrl(p, currentApplist);
                                IsRecodingApplist = false;
                            }
                            else if (p.ProcessName == "firefox" && !IsRecodingApplist)
                            {
                                Console.WriteLine("firefox");
                                IsRecodingApplist = true;
                                GetFirefoxUrl(p, currentApplist);
                                IsRecodingApplist = false;
                            }
                            else if (p.ProcessName == "iexplore" && !IsRecodingApplist)
                            {
                                Console.WriteLine("iexplore");
                                IsRecodingApplist = true;
                                GetInternetExplorerUrl(p, currentApplist);
                                IsRecodingApplist = false;
                            }
                            else if (p.ProcessName == "MicrosoftEdge" && !IsRecodingApplist)
                            {
                                Console.WriteLine("MicrosoftEdge");
                                IsRecodingApplist = true;
                                GetMicrosofEdgeUrl(p, currentApplist);
                                IsRecodingApplist = false;
                            }
                            else if (p.ProcessName == "msedge" && !IsRecodingApplist)
                            {
                                Console.WriteLine("msedge");
                                IsRecodingApplist = true;
                                GetMSEdgeUrl(p, currentApplist);
                                IsRecodingApplist = false;
                            }
                            else
                            {
                                bool is_new = true;
                                for (int i = 0; i < currentApplist.Count; i++)
                                {
                                    if (currentApplist.ElementAt(i).name == p.ProcessName)
                                    {
                                        is_new = false;
                                        break;
                                    }
                                }
                                if (is_new)
                                {
                                    Activity activity = new Activity();
                                    activity.name = p.ProcessName;
                                    activity.activity_minutes = 1;
                                    currentApplist.Add(activity);
                                }
                            }
                        }
                    }
                    bool has_self = false;
                    foreach (Activity currentActivity in currentApplist)
                    {
                        if(currentActivity.name == "DigitalWorkspace")
                        {
                            has_self = true;
                            break;
                        }
                    }
                    if (!has_self)
                    {
                        Activity self_activity = new Activity();
                        self_activity.name = "DigitalWorkspace";
                        self_activity.activity_minutes = 1;
                        currentApplist.Add(self_activity);
                    }
                    foreach (Activity currentActivity in currentApplist)
                    {
                        bool is_new = true;
                        foreach (Activity activity in appList)
                        {
                            if (currentActivity.name == activity.name)
                            {
                                activity.activity_minutes++;
                                is_new = false;
                                foreach (Activity currentDetail in currentActivity.details)
                                {
                                    bool is_new_detail = true;
                                    foreach (Activity realDetail in activity.details)
                                    {
                                        if (currentDetail.name == realDetail.name)
                                        {
                                            is_new_detail = false;
                                            realDetail.activity_minutes++;
                                            break;
                                        }
                                    }
                                    if (is_new_detail)
                                    {
                                        currentDetail.activity_minutes = 1;
                                        activity.details.Add(currentDetail);
                                    }
                                }
                            }
                        }

                        if (is_new)
                        {
                            foreach (Activity detail in currentActivity.details)
                            {
                                detail.activity_minutes = 1;
                            }
                            currentActivity.activity_minutes = 1;
                            appList.Add(currentActivity);
                        }
                    }

                    this.clockinMinutes++;

                    foreach (Activity activity in appList)
                    {
                        if (this.clockinMinutes > 0)
                        {
                            activity.activity_percentage = activity.activity_minutes / this.clockinMinutes * 100;
                            foreach (Activity detail in activity.details)
                            {
                                detail.activity_percentage = detail.activity_minutes / this.clockinMinutes * 100;
                            }
                        }
                        else
                            activity.activity_percentage = 0;
                    }
                    var json = new JavaScriptSerializer().Serialize(this.appList);
                    this.report(json);

                    Record r = new Record();
                    r.applist = this.appList;
                    r.totalMinutes = this.totalTimefromclockin;
                    SerializeObject(r, listInfoPath);
                }
                System.Console.WriteLine(this.totalTimefromclockin);
                if (this.totalTimefromclockin >= 120)
                {
					await uploadApplistInofRequest();
					//if (!isClockin)
					//    checkApplications.Stop();
					//this.totalTimefromclockin = 0;
					//File.Delete(listInfoPath);
					//appList = new List<Activity>();
					//clockinMinutes = 0;
				}
                Console.WriteLine("--------------------end----------------------");
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
        public void SerializeObject<T>(T serializableObject, string fileName)
        {
            if (serializableObject == null) { return; }

            try
            {
                XmlDocument xmlDocument = new XmlDocument();
                XmlSerializer serializer = new XmlSerializer(serializableObject.GetType());
                using (MemoryStream stream = new MemoryStream())
                {
                    serializer.Serialize(stream, serializableObject);
                    stream.Position = 0;
                    xmlDocument.Load(stream);
                    xmlDocument.Save(fileName);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public T DeSerializeObject<T>(string fileName)
        {
            if (string.IsNullOrEmpty(fileName)) { return default(T); }

            T objectOut = default(T);

            try
            {
                XmlDocument xmlDocument = new XmlDocument();
                xmlDocument.Load(fileName);
                string xmlString = xmlDocument.OuterXml;

                using (StringReader read = new StringReader(xmlString))
                {
                    Type outType = typeof(T);

                    XmlSerializer serializer = new XmlSerializer(outType);
                    using (XmlReader reader = new XmlTextReader(read))
                    {
                        objectOut = (T)serializer.Deserialize(reader);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.Write(ex.ToString());
                return default(T);
            }

            return objectOut;
        }

        public async void AutoCheck_TickAsync(object sender, EventArgs e) {

            Console.WriteLine("checking start....");
            using (var httpClient = new HttpClient())
            {
                string url = this.serverUrl + "/getLoginResponse";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        Console.WriteLine("Something went wrong. Please try again!");
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Auth>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            userOutletId = JSONObj.data.session.user.UserOutlet["id"].ToString();
                            if(this.screenshot_interval != Int32.Parse(JSONObj.data.screenshot_interval))
                            {
                                screenshot_interval = Int32.Parse(JSONObj.data.screenshot_interval);
                                this.dispatcherTimer.Interval = new TimeSpan(0, 0, screenshot_interval);
                            }
                                
                            first_name = JSONObj.data.session.user.first_name.ToString();
                            last_name = JSONObj.data.session.user.last_name.ToString();
                            this.bAllowAttendance = JSONObj.data.bAllowAttendance;
                            this.clockinViewModel.initView();
                            if (JSONObj.data.last_check_in == null )
                            {
                                this.stop_capture();
                                if (this.isClockin && this.bAllowAttendance)
                                    this.login();
                            }
                            else
                            {
                                this.start_capture();
                                if (!this.isClockin)
                                {
                                    await this.tasksMeetingsRequest();
                                    this.clockinViewModel.keepClocking();
                                }
                            }
                            return;
                        }
                        else
                        {
                            message = JSONObj.data.message.ToString();
                            if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                                this.alertShow(message);
                            }
                            //this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    //this.alertShow(message);
                    //this.logout();
                    return;
                }
            }
        }

        public void alertShow(string message)
        {
            popupBox.IsOpen = true;
            AlertMessageBox.Content = message;
            keepMessage.Stop();
            keepMessage.Start();
        }
        public void hideMessage()
        {
            popupBox.IsOpen = false;
        }
        private void dispatcherTimer_Tick(object sender, EventArgs e)
        {
            Console.WriteLine("------------working-----------------");
            screenCapture();
        }

        private void checkApplications_Tick(object sender, EventArgs e)
        {
            new Thread(checkApplist).Start();
        }

        private void keepMessage_Tick(object sender, EventArgs e)
        {
            this.keepMessage.Stop();
            this.hideMessage();
        }

        public void login()
        {
            isClockin = false;
            dispatcherTimer.Stop();
            RefreshMeetingTasks.Stop();
            if (!this.bAllowAttendance)
            {
                clockin();
                return;
            }
            if (this.welcomeViewModel == null)
            {
                welcomeViewModel = new WelcomeViewModel(this);
            }
            welcomeViewModel.FirstName = this.first_name;
            welcomeViewModel.LastName = this.last_name;
            DataContext = welcomeViewModel;
            welcomeViewModel.initView();
        }

        public void clockin()
        {
            if (!this.isClockin)
            {
                this.start_capture();
                this.isClockin = true;
            }

            RefreshMeetingTasks.Start();
            clockinViewModel.refresh_list();
            DataContext = clockinViewModel;
            clockinViewModel.initView();
        }

        public void logout()
        {
            RefreshMeetingTasks.Stop();
            isClockin = false;
            this.stop_capture();
            //this.checkApplications.Stop();
            this.AutoCheck.Stop();
            this.token = "";
            this.screenshot_interval = 600;
            if (!this.loginViewModel.isRemembered)
            {
                this.loginViewModel.clearPassword();
                this.loginViewModel.Email = "";
            }
            this.dispatcherTimer.Interval = new TimeSpan(0, 10, 0);
            DataContext = loginViewModel;
        }

        public void createTaskView(bool IsTask)
        {
            RefreshMeetingTasks.Stop();
            this.createViewModel.refresh_all();
            this.createViewModel.IsTask = IsTask;
            DataContext = createViewModel;
        }
        protected override void OnClosed(EventArgs e)
        {
            base.OnClosed(e);
            Application.Current.Shutdown();
        }
        public void createTaskView(bool IsTask, TaskItem selectedTaskItem)
        {
            RefreshMeetingTasks.Stop();
            if (selectedTaskItem != null) { 
                this.createViewModel.refresh_all();
                this.createViewModel.task_id = selectedTaskItem.id;
                this.createViewModel.jobTitle = selectedTaskItem.title;
                this.createViewModel.startTime = selectedTaskItem.start_time + " " + selectedTaskItem.start_period.ToLower();
                this.createViewModel.endTime = selectedTaskItem.end_time + " " + selectedTaskItem.end_period.ToLower();
                try
                {
                    string validformat = "yyyy-MM-dd";
                    CultureInfo provider = new CultureInfo("en-US");
                    DateTime d1;
                    if (selectedTaskItem.start_date == "Tomorrow")
                    {
                        d1 =DateTime.Today.AddDays(1);
                    }
                    else if(selectedTaskItem.start_date == "Today")
                    {
                        d1 =DateTime.Today;
                    }
                    else
                    {
                        d1 = DateTime.ParseExact(selectedTaskItem.start_date, validformat, provider);
                    }
                    
                    this.createViewModel.DueDate =  d1;
                }
                catch
                {

                }
                
                if (selectedTaskItem.tags != null && selectedTaskItem.tags != "")
                {
                    string[] tagsArray = selectedTaskItem.tags.Split(',');
                    ObservableCollection<Tag> oTags = new ObservableCollection<Tag>();
                    foreach (var tag in tagsArray)
                    {
                        oTags.Add(new Tag(tag));
                    }
                    this.createViewModel.tags = oTags;
                }
                this.createViewModel.IsTask = IsTask;
                DataContext = createViewModel;
            }
            else
            {
                this.alertShow("Please select item to edit");
            }
        }

        public void createTaskView(bool IsTask, MeetingItem selectedMeetingItem)
        {
            RefreshMeetingTasks.Stop();
            if (selectedMeetingItem != null)
            {
                this.createViewModel.refresh_all();
                this.createViewModel.meeting_id = selectedMeetingItem.id;
                this.createViewModel.meetingTitle = selectedMeetingItem.title;
                this.createViewModel.InviteLink = selectedMeetingItem.link;
                this.createViewModel.LogoPath = selectedMeetingItem.image;
                this.createViewModel.IsTask = IsTask;
                DataContext = createViewModel;
            }
            else
            {
                this.alertShow("Please select item to edit");
            }
        }

        public async Task loginRequest(string email_phone, String pwd)
        {
            using (var httpClient = new HttpClient())
            {
                this.loginViewModel.canLogin = false;
                this.alertShow("Connecting...");
                string url = this.serverUrl + "/login";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent(email_phone), "email");
                form.Add(new StringContent(pwd), "password");
                form.Add(new StringContent("json"), "dataType");
                form.Add(new StringContent("1"), "desktopApp");
                form.Add(new StringContent("desktop"), "appType");

                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);

                    response.EnsureSuccessStatusCode();

                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        this.alertShow("Something went wrong. Please try again!");
                        this.loginViewModel.canLogin = true;
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Auth>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            token = JSONObj.data.session.user.auth_token.ToString();
                            userOutletId = JSONObj.data.session.user.UserOutlet["id"].ToString();
                            screenshot_interval = Int32.Parse(JSONObj.data.screenshot_interval);
                            first_name = JSONObj.data.session.user.first_name.ToString();
                            last_name = JSONObj.data.session.user.last_name.ToString();
                            user_id = JSONObj.data.session.user.id.ToString();
                            appListInfoInitAsync();
                            this.bAllowAttendance = JSONObj.data.bAllowAttendance;
                            int min = screenshot_interval / 60;
                            int sec = screenshot_interval % 60;
                            this.dispatcherTimer.Interval = new TimeSpan(0, 0, screenshot_interval);
                            if(!this.AutoCheck.IsEnabled)
                                this.AutoCheck.Start();
                            if (JSONObj.data.last_check_in != null || !this.bAllowAttendance)
                            {
                                this.clockinViewModel.IsTask = true;
                                await this.tasksMeetingsRequest();
                                this.loginViewModel.canLogin = true;
                            }
                            else
                            {
                                this.login();
                                this.loginViewModel.canLogin = true;
                            }
                            return;
                        }
                        else
                        {
                            message = JSONObj.data.message.ToString();
                            this.alertShow(message);
                            this.loginViewModel.canLogin = true;
                            return;
                        }
                    
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    this.alertShow(message);
                    return;
                }
            }
        }

        public async Task clockinRequest()
        {
            using (var httpClient = new HttpClient())
            {
                this.alertShow("Connecting...");
                string url = this.serverUrl + "/web-attendance";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent("in"), "type");
                form.Add(new StringContent("0"), "req-outlet-id");
                form.Add(new StringContent("53.901594"), "user_lat");
                form.Add(new StringContent("25.277648"), "user_lon");
                form.Add(new StringContent("desktop"), "appType");
                try
                {

                    HttpResponseMessage response = await httpClient.PostAsync(url, form);

                    response.EnsureSuccessStatusCode();

                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        this.alertShow("Something went wrong. Please try again!");
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            await tasksMeetingsRequest();
                            this.clockinViewModel.IsTask = true;
                            this.clockinViewModel.keepClocking();
                            this.clockin();
                            message = JSONObj.data["message"].ToString();
                            this.alertShow(message);
                            return;
                        }
                        else
                        {
                            message = JSONObj.data["message"].ToString();
                            if (JSONObj.error == "501")
                            {
                                await tasksMeetingsRequest();
                                this.clockinViewModel.keepClocking();
                                this.clockin();
                            }
                            else if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                            }
                            this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    this.alertShow(message);
                    //this.logout();
                    return;
                }
            }
        }
        public async void finishRequest(string id)
        {
            using (var httpClient = new HttpClient())
            {
                this.alertShow("Connecting...");
                string url = this.serverUrl + "/roster-mark-complete";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent(id), "schedule_id");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);

                    response.EnsureSuccessStatusCode();

                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        this.alertShow("Something went wrong. Please try again!");
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            await tasksMeetingsRequest();
                            message = JSONObj.data["message"].ToString();
                            this.alertShow(message);
                            return;
                        }
                        else
                        {
                            message = JSONObj.data["message"].ToString();
                            if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                            }
                            this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    this.alertShow(message);
                    //this.logout();
                    return;
                }
            }
        }
        public async Task tasksMeetingsRequest()
        {
            using (var httpClient = new HttpClient())
            {
                this.alertShow("Connecting...");
                string url = this.serverUrl + "/digital-workspace";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                    return;
                }
                else form.Add(new StringContent(this.token), "token");
                if (this.userOutletId == "" || this.userOutletId == null)
                {
                    this.isClockin = false;
                    message = "Invalid user outlet ID.";
                    this.alertShow(message);
                    this.logout();
                    return;
                }
                else form.Add(new StringContent(this.userOutletId), "userOutletId");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        //this.isClockin = false;
                        message = "Something went wrong. Please try again!";
                        this.alertShow(message);
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Auth>(responseBody.Result.ToString());

                        if (JSONObj.status == 1)
                        {
                            meetingRooms = JSONObj.data.meetingRooms;
                            tasks = JSONObj.data.tasks;
                            //this.bAllowAddTask = JSONObj.data.bAllowAddTask;
                            //this.bAllowAddMeetingRoom = JSONObj.data.bAllowAddMeetingRoom;
                            this.bAllowAddTask = JSONObj.data.bAllowAddTask;
                            this.bAllowAddMeetingRoom = JSONObj.data.bAllowAddMeetingRoom;
                            this.clockin();
                            return;
                        }
                        else
                        {
                            this.isClockin = false;
                            message = JSONObj.data.message.ToString();
                            if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                            }
                            this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    this.alertShow(message);
                    //this.logout();
                    return;
                }

            }
        }
        public async Task uploadApplistInofRequest()
        {
            if (this.appList.Count > 0)
            {
                using (var httpClient = new HttpClient())
                {
                    //this.alertShow("Connecting...");

                    string url = this.serverUrl + "/app-activity";
                    MultipartFormDataContent form = new MultipartFormDataContent();
                    form.Add(new StringContent("json"), "dataType");
                    if (this.token == "" || this.token == null)
                    {
                        this.isClockin = false;
                        message = "You have been logged out.";
                        this.alertShow(message);
                        this.logout();
                        return;
                    }
                    else form.Add(new StringContent(this.token), "token");
                    form.Add(new StringContent("browser-activity"), "type");
                    var json = new JavaScriptSerializer().Serialize(this.appList);
                    Console.WriteLine(json);
                    form.Add(new StringContent(json), "activity");
                    form.Add(new StringContent("desktop"), "appType");
                    this.report(json);
                    try
                    {
                        HttpResponseMessage response = await httpClient.PostAsync(url, form);
                        response.EnsureSuccessStatusCode();
                        Task<string> responseBody = response.Content.ReadAsStringAsync();

                        if (response.StatusCode.ToString() != "OK")
                        {
                            message = "Something went wrong. Please try again!";
                            //this.alertShow(message);
                            //this.logout();
                            return;
                        }
                        else
                        {
                            var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                            if (JSONObj.status == 1)
                            {
                                message = JSONObj.data["message"].ToString();
                                //this.alertShow(message);
                                Console.WriteLine(message);
                                //if (!isClockin)
                                //    checkApplications.Stop();
                                string listInfoPath = capture_directory + "\\" + this.user_id + "_info.xml";
                                File.Delete(listInfoPath);
                                appList = new List<Activity>();
                                clockinMinutes = 0;
                                totalTimefromclockin = 0;
                                return;
                            }
                            else
                            {
                                message = JSONObj.data["message"].ToString();
                                if (JSONObj.error == "311")
                                {
                                    message = "You have been logged out.";
                                    this.logout();
                                    this.alertShow(message);
                                }
                                //this.alertShow(message);
                                return;
                            }

                        }
                    }
                    catch
                    {
                        message = "Something went wrong. Please try again!";
                        //this.alertShow(message);
                        //this.logout();
                        return;
                    }
                }
            }
            else
            {
                appList = new List<Activity>();
                clockinMinutes = 0;
                totalTimefromclockin = 0;
                return;
            }
        }
        public async Task logoutRequest()
        {
            RefreshMeetingTasks.Stop();
            this.stop_capture();
            this.AutoCheck.Stop();
			await uploadApplistInofRequest();
			using (var httpClient = new HttpClient())
            {
                this.alertShow("Connecting...");
                string url = this.serverUrl + "/logout";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                    return;
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    this.clockinViewModel.ClockoutButtonEnable = false;
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    this.clockinViewModel.ClockoutButtonEnable = true;
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();
                    if (response.StatusCode.ToString() != "OK")
                    {
                        message = "Something went wrong. Please try again!";
                        this.alertShow(message);
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            this.logout();
                            //message = JSONObj.data["message"].ToString();
                            message = "Logged out successfully";
                            this.alertShow(message);
                            return;
                        }
                        else
                        {
                            message = JSONObj.data["message"].ToString();
                            if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                            }
                            this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                    return;
                }
            }
        }
        public async Task clockoutRequest()
        {
            using (var httpClient = new HttpClient())
            {
                this.alertShow("Connecting...");
                string url = this.serverUrl + "/web-attendance";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                    return;
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent("out"), "type");
                form.Add(new StringContent("0"), "req-outlet-id");
                form.Add(new StringContent("53.901594"), "user_lat");
                form.Add(new StringContent("25.277648"), "user_lon");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    this.clockinViewModel.ClockoutButtonEnable = false;
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    this.clockinViewModel.ClockoutButtonEnable = true;
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();

                    if (response.StatusCode.ToString() != "OK")
                    {
                        message = "Something went wrong. Please try again!";
                        this.alertShow(message);
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
							uploadApplistInofRequest();
							this.login();
                            message = JSONObj.data["message"].ToString();
                            this.alertShow(message);
                            return;
                        }
                        else
                        {
                            message = JSONObj.data["message"].ToString();
                            if (JSONObj.error == "702")
                            {
                                this.clockinViewModel.keepClocking();
                            }
                            else if (JSONObj.error == "501")
                            {
                                this.clockinViewModel.keepClocking();
								uploadApplistInofRequest();
								this.login();
                            }
                            else if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                            }
                            this.alertShow(message);
                            return;
                        }
                    
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    this.alertShow(message);
                    //this.logout();
                    return;
                }
            }
        }
        public async  Task createMeetingRequest(string meeting_id, string meetingTitle, string MeetingDate, string InviteLink, string LogoPath)
        {
            try
            {
                using (var httpClient = new HttpClient())
                {
                    string url = this.serverUrl + "/add-meeting-room";
                    MultipartFormDataContent form = new MultipartFormDataContent();
                    var webClient = new WebClient();
                    //byte[] picture = File.ReadAllBytes(LogoPath);
                    try
                    {
                        byte[] picture = webClient.DownloadData(LogoPath);
                        form.Add(new ByteArrayContent(picture, 0, picture.Length), "logo", "logo.jpg");
                    }
                    catch
                    {

                    }
                    
                    form.Add(new StringContent("json"), "dataType");
                    if (this.token == "" || this.token == null)
                    {
                        this.isClockin = false;
                        message = "You have been logged out.";
                        this.alertShow(message);
                        this.logout();
                    }
                    else form.Add(new StringContent(this.token), "token");
                    form.Add(new StringContent(meetingTitle), "meeting-title");
                    string preMsg = "Creating...";
                    if (meeting_id != "" && meeting_id != null)
                    {
                        form.Add(new StringContent(meeting_id), "meeting-id");
                        preMsg = "Updating...";
                    }
                    this.alertShow(preMsg);
                    form.Add(new StringContent("true"), "bMultipartFormDocuments");
                    
                    form.Add(new StringContent(InviteLink), "meeting-link");
                    form.Add(new StringContent("desktop"), "appType");
                    try
                    {
                        HttpResponseMessage response = await httpClient.PostAsync(url, form);
                        response.EnsureSuccessStatusCode();
                        Task<string> responseBody = response.Content.ReadAsStringAsync();
                        if (response.StatusCode.ToString() != "OK")
                        {
                            this.alertShow("Something went wrong. Please try again!");
                            //this.logout();
                            return;
                        }
                        else
                        {
                            var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                            if (JSONObj.status == 1)
                            {
                                await tasksMeetingsRequest();
                                this.clockinViewModel.IsTask = false;
                                this.clockin();
                                string message = "Meeting created successfully!";
                                if (meeting_id != "" && meeting_id != null)
                                {
                                    message = "Meeting updated successfully!";
                                }
                                this.alertShow(message);
                                return;
                            }
                            else
                            {

                                message = JSONObj.data["message"].ToString();
                                if (JSONObj.error == "311")
                                {
                                    message = "You have been logged out.";
                                    this.logout();
                                }
                                this.alertShow(message);
                                return;
                            }
                        
                        }
                    }
                    catch
                    {
                        //this.isClockin = false;
                        message = "Something went wrong. Please try again!";
                        this.alertShow(message);
                        //this.logout();
                        return;
                    }
                }
            }
            catch(Exception e)
            {
                Console.WriteLine(e);
            }
        }

        public async Task createTaskRequest(string id, string jobTitle, string DueDate, string weekday, string startTime, string endTime, string start_period, string end_period, string tagsString)
        {
            using (var httpClient = new HttpClient())
            {               
                string url = this.serverUrl + "/add-task";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                string preMsg = "Creating...";
                if (id != "" && id != null)
                {
                    form.Add(new StringContent(id), "schedule_id");
                    preMsg = "Updating...";
                }
                this.alertShow(preMsg);
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent(jobTitle), "job_title");
                form.Add(new StringContent(userOutletId), "user_outlet_ids");
                form.Add(new StringContent(DueDate), "start_date");
                form.Add(new StringContent(DueDate), "end_date");
                form.Add(new StringContent("timings"), "roster_duration");
                form.Add(new StringContent(startTime), "start_time");
                form.Add(new StringContent(start_period), "start_period");
                form.Add(new StringContent(endTime), "end_time");
                form.Add(new StringContent(end_period), "end_period");
                form.Add(new StringContent(weekday), "weekday");
                form.Add(new StringContent("outlet"), "roster_location");
                form.Add(new StringContent(tagsString), "tags");
                form.Add(new StringContent("2"), "type");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();
                    if (response.StatusCode.ToString() != "OK")
                    {
                        this.alertShow("Something went wrong. Please try again!");
                        return;
                    }
                    else
                    {
                    
                        var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            await tasksMeetingsRequest();
                            this.createViewModel.refresh_all();
                            this.clockin();
                            string message = "Task created successfully!";
                            if (id != "" && id != null)
                            {
                                message = "Task updated successfully!";
                            }
                            this.alertShow(message);
                            return;
                        }
                        else
                        {
                            string error = JSONObj.data["error"].ToString();
                            message = JSONObj.data["message"].ToString();
                            if (error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                            }
                            this.alertShow(message);
                            return;
                        }
                    }    
                }
                catch(Exception e)
                {
                    //MessageBox.Show(e.ToString());
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    this.alertShow(message);
                    //this.logout();
                    return;
                }
            }
        }
        [System.Runtime.InteropServices.DllImport("gdi32.dll")]
        public static extern bool DeleteObject(IntPtr hObject);
        public void screenCapture()
        {
            string ScreenPath = capture_directory + "\\temp.jpg";
            Bitmap screenShotBMP;
            BitmapSource bitmap = null;
            double dpiFactor = System.Windows.PresentationSource.FromVisual(this).CompositionTarget.TransformToDevice.M11;
            screenShotBMP = new System.Drawing.Bitmap((int)(SystemParameters.PrimaryScreenWidth * dpiFactor),
                (int)(SystemParameters.PrimaryScreenHeight * dpiFactor), System.Drawing.Imaging.PixelFormat.Format32bppArgb);
            using (System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(screenShotBMP))
            {
                g.CopyFromScreen(0, 0, 0, 0, screenShotBMP.Size);
            }
            IntPtr handle = IntPtr.Zero;
            try
            {
                handle = screenShotBMP.GetHbitmap();
                bitmap = System.Windows.Interop.Imaging.CreateBitmapSourceFromHBitmap(handle, IntPtr.Zero, Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
                using (var memoryStream = new MemoryStream())
                {
                    BitmapEncoder encoder = new PngBitmapEncoder();
                    encoder.Frames.Add(BitmapFrame.Create(bitmap));
                    encoder.Save(memoryStream);
                    UploadUserPictureApiCommandAsync(memoryStream.ToArray());
                }
            }
            catch
            {
                this.alertShow("Something went wrong. Please try again!");
                return;
            }
            finally
            {
                DeleteObject(handle);
            }
        }
        public async void UploadUserPictureApiCommandAsync(byte[] picture)
        {
            Console.WriteLine("---started capture");
            using (var httpClient = new HttpClient())
            {
                string url = this.serverUrl + "/save-screenshots";
                MultipartFormDataContent form = new MultipartFormDataContent();
                form.Add(new StringContent("json"), "dataType");
                if (this.token == "" || this.token == null)
                {
                    this.isClockin = false;
                    message = "You have been logged out.";
                    this.alertShow(message);
                    this.logout();
                }
                else form.Add(new StringContent(this.token), "token");
                form.Add(new StringContent("true"), "bMultipartFormDocuments");
                form.Add(new ByteArrayContent(picture, 0, picture.Length), "screens", "screen.jpg");
                form.Add(new StringContent("desktop"), "appType");
                try
                {
                    HttpResponseMessage response = await httpClient.PostAsync(url, form);
                    response.EnsureSuccessStatusCode();
                    Task<string> responseBody = response.Content.ReadAsStringAsync();
                    if (response.StatusCode.ToString() != "OK")
                    {
                        this.alertShow("Something went wrong. Please try again!");
                        //Console.WriteLine(message);
                        //this.logout();
                        return;
                    }
                    else
                    {
                        var JSONObj = new JavaScriptSerializer().Deserialize<Response>(responseBody.Result.ToString());
                        if (JSONObj.status == 1)
                        {
                            Console.WriteLine("---uploaded success");
                            return;
                        }
                        else
                        {
                            message = JSONObj.data["message"].ToString();
                            if (JSONObj.error == "311")
                            {
                                message = "You have been logged out.";
                                this.logout();
                                this.alertShow(message);
                            }
                            //this.alertShow(message);
                            return;
                        }
                    }
                }
                catch
                {
                    //this.isClockin = false;
                    message = "Something went wrong. Please try again!";
                    //this.alertShow(message);
                    //this.logout();
                    return;
                }
            }
        }

        public void report(String text)
        {
            string reportPath = capture_directory + "\\report.log";
            using (StreamWriter writer = File.AppendText(reportPath))
            {
                writer.WriteLine("--------------------"+DateTime.Now.ToString()+"--------------------");
                writer.WriteLine(text);
                writer.Close();
            }
        }
    }
}
