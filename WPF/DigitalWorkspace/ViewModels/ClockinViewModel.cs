using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Input;
using System.Windows.Threading;

namespace DigitalWorkspace.ViewModels
{
    
    public class ClockinViewModel : INotifyPropertyChanged
    {
        MainWindow main;
        public ICommand ClockoutButtonCommand { get; set; }
        public ICommand CreateButtonCommand { get; set; }
        public ICommand EditButtonCommand { get; set; }
        public ICommand SelectButtonCommand { get; set; }
        public ICommand TasksMenuButtonCommand { get; set; }
        public ICommand MeetingsMenuButtonCommand { get; set; }
        public ICommand LogoutButtonCommand { get; set; }
        public ICommand RedirectButtonCommand { get; set; }
        public ICommand SaveClipboardButtonCommand { get; set; }
        bool _isTask;
        public event PropertyChangedEventHandler PropertyChanged;
        DispatcherTimer keepClockin;
        public bool IsTask
        {
            get
            {
                return _isTask;
            }
            set
            {
                if(_isTask != value)
                {
                    _isTask = value;
                    this.SelectedMeeting = null;
                    this.SelectedTask = null;
                    OnPropertyChanged("getTasksMenuColor");
                    OnPropertyChanged("getMeetingsMenuColor");
                    OnPropertyChanged("getTasksMenuBottomColor");
                    OnPropertyChanged("getMeetingsMenuBottomColor");
                    OnPropertyChanged("getTasksVisibility");
                    OnPropertyChanged("getMeetingsVisibility");
                    OnPropertyChanged("emptyTaskVisibility");
                    OnPropertyChanged("emptyMeetingVisibility");
                    OnPropertyChanged("EditbuttonEnabled");
                    OnPropertyChanged("EditbuttonImage");
                    OnPropertyChanged("EditbuttonColor");
                    OnPropertyChanged("manageTaskVisibility");
                }
            }
        }
        public string VisibilityClockoutButton
        {
            get
            {
                if (this.main.bAllowAttendance)
                {
                    return "Visible";
                }
                else
                {
                    return "Hidden";
                }
            }
        }
        public string manageTaskVisibility
        {
            get
            {
                if (this.IsTask)
                {
                    if (main.bAllowAddTask)
                    {
                        return "Visible";
                    }
                    else
                    {
                        return "Hidden";
                    }
                }
                else
                {
                    if (main.bAllowAddMeetingRoom)
                    {
                        return "Visible";
                    }
                    else
                    {
                        return "Hidden";
                    }
                }
            }
        }
        public ObservableCollection<TaskRoom> tasks;
        public ObservableCollection<MeetingRoom> meetingRooms;
        private ObservableCollection<TaskItem> tasklist;
        private ObservableCollection<MeetingItem> meetinglist;
        private TaskItem _selectedTask;
        private MeetingItem _selectedMeeting;
        public TaskItem SelectedTask 
        {
            get 
            {
                return _selectedTask;
            }
            set
            {
                _selectedTask = value;
                OnPropertyChanged("SelectedTask");
                OnPropertyChanged("EditbuttonEnabled");
                OnPropertyChanged("EditbuttonImage");
                OnPropertyChanged("EditbuttonColor");
            }
        }
        public void initView()
        {
            OnPropertyChanged("manageTaskVisibility");
            OnPropertyChanged("VisibilityClockoutButton");
        }
        public MeetingItem SelectedMeeting
        {
            get
            {
                return _selectedMeeting;
            }
            set
            {
                _selectedMeeting = value;
                OnPropertyChanged("SelectedMeeting");
                OnPropertyChanged("EditbuttonEnabled");
                OnPropertyChanged("EditbuttonImage");
                OnPropertyChanged("EditbuttonColor");
            }
        }
        public bool EditbuttonEnabled
        {
            get
            {
                if (IsTask)
                {
                    if(this.SelectedTask != null)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    if (this.SelectedMeeting != null)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
        public string EditbuttonColor
        {
            get
            {
                if (IsTask)
                {
                    if (this.SelectedTask != null)
                    {
                        return "#6AD1DF";
                    }
                    else
                    {
                        return "#999999";
                    }
                }
                else
                {
                    if (this.SelectedMeeting != null)
                    {
                        return "#6AD1DF";
                    }
                    else
                    {
                        return "#999999";
                    }
                }
            }
        }
        public string EditbuttonImage
        {
            get
            {
                if (IsTask)
                {
                    if (this.SelectedTask != null)
                    {
                        return "/Images/ic_update_highlight@2x.png";
                    }
                    else
                    {
                        return "/Images/ic_create_24px@2x.png";
                    }
                }
                else
                {
                    if (this.SelectedMeeting != null)
                    {
                        return "/Images/ic_update_highlight@2x.png";
                    }
                    else
                    {
                        return "/Images/ic_create_24px@2x.png";
                    }
                }
            }
        }
        string token;
        public ClockinViewModel()
        {
            this.main = App.Current.MainWindow as MainWindow;
            this.IsTask = IsTask;
            ClockoutButtonCommand = new DWCommands(o => ClockoutButtonClick("ClockoutButton"));
            CreateButtonCommand = new DWCommands(o => CreateButtonClick("CreateButton"));
            EditButtonCommand = new DWCommands(o => EditButtonClick("EditButton"));
            TasksMenuButtonCommand = new DWCommands(o => TasksMenuButtonClick("TasksMenuButton"));
            MeetingsMenuButtonCommand = new DWCommands(o => MeetingsMenuButtonClick("MeetingsMenuButton"));
            LogoutButtonCommand = new DWCommands(o => LogoutButtonClick("logoutButton"));
            RedirectButtonCommand = new DWCommands(o => RedirectButtonClick(o));
            SelectButtonCommand = new DWCommands(o => SelectButtonClick(o));
            SaveClipboardButtonCommand = new DWCommands(o => SaveClipboardButtonClick(o));
            IsTask = true;
            token = this.main.token;
            tasks = main.tasks;
            this.keepClockin = new DispatcherTimer();
            this.keepClockin.Interval = new TimeSpan(0, 0, 60);
            this.keepClockin.Tick += keepClockin_Tick;
            tasklist = new ObservableCollection<TaskItem>();
            meetinglist = new ObservableCollection<MeetingItem>();
            ClockoutButtonEnable = true;
            if (tasks != null)
                foreach (TaskRoom atask in tasks)
                {
                    string title = atask.Schedule["job_title"];
                    string id = atask.Schedule["id"];
                    string status = atask.Schedule["status"];
                    string dueDate = "";
                    DateTime date = Convert.ToDateTime(atask.Schedule["end_date"]);
                    if (date > DateTime.Now.AddDays(1) && date <= DateTime.Now.AddDays(2))
                    {
                        dueDate = "Tomorrow";
                    }
                    else if (date <= DateTime.Now.AddDays(1) && date > DateTime.Now)
                    {
                        dueDate = "Today";
                    }
                    else
                    {
                        dueDate = date.Day + "/" + date.Month + "/" + date.Year;
                    }
                    string tags = atask.Schedule["tags"];
                    string end_date = atask.Schedule["end_date"];
                    string start_time = atask.Schedule["start_time"];
                    string end_time = atask.Schedule["end_time"];
                    tasklist.Add(new TaskItem(id, title, dueDate,start_time, end_time, end_date, tags, status));
                }
            meetingRooms = main.meetingRooms;
            if (meetingRooms != null)
                foreach (MeetingRoom ameeting in meetingRooms)
                {
                    string title = ameeting.name;
                    string link = ameeting.link;
                    string image = this.main.serverUrl + ameeting.image;
                    string startTime = ameeting.timing;
                    string platform = ameeting.platform;
                    string id = ameeting.id;
                    meetinglist.Add(new MeetingItem(id, title, startTime, platform, link, image));
                }
            this.keepClocking();
        }
        public void refresh_list()
        {
            this.SelectedMeeting = null;
            this.SelectedTask = null;
            tasks = main.tasks;
            tasklist.Clear();
            if (tasks != null)
                for (var i = 0; i < tasks.Count; i++)
                {
                    string title = tasks[i].Schedule["job_title"];
                    string id = tasks[i].Schedule["id"];
                    string status = tasks[i].Schedule["status"];
                    string dueDate = "";
                    DateTime date = Convert.ToDateTime(tasks[i].Schedule["end_date"]);
                    DateTime today = DateTime.Today;
                    if (date > today && date <= today.AddDays(1))
                    {
                        dueDate = "Tomorrow";
                    }
                    else if (date <= today && date > today.AddDays(-1))
                    {
                        dueDate = "Today";
                    }
                    else
                    {
                        dueDate = date.ToString("yyyy-MM-dd");
                    }
                    string tags = tasks[i].Schedule["tags"];
                    string end_date = tasks[i].Schedule["end_date"];
                    string start_time = tasks[i].Schedule["start_time"];
                    string end_time = tasks[i].Schedule["end_time"];
                    tasklist.Add(new TaskItem(id, title, dueDate, start_time, end_time, end_date, tags, status));
                }
            meetingRooms = main.meetingRooms;
            meetinglist.Clear();
            if (meetingRooms != null)
                for (var i = 0; i < meetingRooms.Count; i++)
                {
                    string title = meetingRooms[i].name;
                    string link = meetingRooms[i].link;
                    string image = this.main.serverUrl + meetingRooms[i].image;
                    string startTime = meetingRooms[i].timing;
                    string platform = meetingRooms[i].platform;
                    string id = meetingRooms[i].id;
                    meetinglist.Add(new MeetingItem(id, title, startTime, platform, link, image));
                }

            OnPropertyChanged("emptyTaskVisibility");
            OnPropertyChanged("emptyMeetingVisibility");
            OnPropertyChanged("VisibilityClockoutButton");
        }
        private void keepClockin_Tick(object sender, EventArgs e)
        {
            this.keepClockin.Stop();
            this.ClockoutButtonEnable = true;
        }

        private void ClockoutButtonClick(object sender)
        {
            /*  int status = */
            main.clockoutRequest();//.Result;
            //if (status != 2)
            //{
            //    this.ClockoutButtonEnable = true;
            //}
        }

        private void CreateButtonClick(object sender)
        {
            main.createTaskView(this.IsTask);
        }

        private void EditButtonClick(object sender)
        {
            if (this.IsTask)
            {
                main.createTaskView(this.IsTask, this.SelectedTask);
            }
            else
            {
                main.createTaskView(this.IsTask, this.SelectedMeeting);
            }
        }

        private async void LogoutButtonClick(object sender)
        {
            await main.logoutRequest();
            main.logout();
        }

        private void TasksMenuButtonClick(object sender)
        {
            this.IsTask = true;
        }

        private void MeetingsMenuButtonClick(object sender)
        {
            this.IsTask = false;
        }
        private void RedirectButtonClick(object sender)
        {
            String url = sender.ToString();
            if(url.Contains("http://") || url.Contains("https://"))
            {
                System.Diagnostics.Process.Start(sender.ToString());
            }
            else if(url.Contains("."))
            {
                System.Diagnostics.Process.Start("http://" + sender.ToString());
            }
            else
            {
                System.Diagnostics.Process.Start(this.main.serverUrl + "/" + sender.ToString());
            }
        }

        private void SaveClipboardButtonClick(object sender)
        {
            Clipboard.SetText(sender.ToString());
            main.alertShow("Link copied to clipboard!");
        }
        public void SelectButtonClick(object sender)
        {
            this.main.finishRequest(sender.ToString());
        }
        public string getTasksMenuColor
        {
            get
            {
                if (this.IsTask)
                {
                    return "#6ad1df";
                }
                else
                {
                    return "#999999";
                }
            }
        }

        public string getMeetingsMenuColor
        {
            get
            {
                if (this.IsTask)
                {
                    return "#999999";
                }
                else
                {
                    return "#6ad1df";
                }
            }
        }
        public string getTasksMenuBottomColor
        {
            get
            {
                if (this.IsTask)
                {
                    return "#6ad1df";
                }
                else
                {
                    return "Transparent";
                }
            }
        }

        public string getMeetingsMenuBottomColor
        {
            get
            {
                if (this.IsTask)
                {
                    return "Transparent";
                }
                else
                {
                    return "#6ad1df";
                }
            }
        }
        public string getTasksVisibility
        {
            get
            {
                if (this.IsTask)
                {
                    if (tasklist.Count == 0)
                    {
                        return "Hidden";
                    }
                    else
                        return "Visible";
                }
                else
                {
                    return "Hidden";
                }
            }
        }
        
        public string getMeetingsVisibility
        {
            get
            {
                if (this.IsTask)
                {
                    return "Hidden";
                }
                else
                {
                    if (meetinglist.Count == 0)
                    {
                        return "Hidden";
                    }
                    else
                        return "Visible";
                }
            }
        }
        public string emptyMeetingVisibility
        {
            get
            {
                if (this.IsTask)
                {
                    return "Hidden";
                }
                else
                {
                    if(meetinglist.Count > 0)
                    {
                        return "Hidden";
                    }
                    else
                        return "Visible";
                }
            }
        }
        public string emptyTaskVisibility
        {
            get
            {
                if (this.IsTask)
                {
                    if (tasklist.Count > 0)
                    {
                        return "Hidden";
                    }
                    else
                        return "Visible";
                }
                else
                {
                    return "Hidden";
                }
            }
        }
        private bool _clockoutButtonEnable;
        public bool ClockoutButtonEnable
        {
            set
            {
                this._clockoutButtonEnable = value;
                OnPropertyChanged("ClockoutButtonEnable");
            }
            get
            {
                return _clockoutButtonEnable;
            }
        }
        public void keepClocking()
        {
            //this.keepClockin.Stop();
            //this.ClockoutButtonEnable = false;
            //this.keepClockin.Start();
        }

        public ObservableCollection<TaskItem> TaskItems
        {
            get
            {
                return tasklist;
            }
        }
        public ObservableCollection<MeetingItem> MeetingItems
        {
            get
            {
                return meetinglist;
            }
        }
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}
