using Microsoft.Win32;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace DigitalWorkspace.ViewModels
{
    public class CreateViewModel : INotifyPropertyChanged
    {
        MainWindow main;
        public ICommand CreateTaskButtonCommand { get; set; }
        public ICommand CreateMeetingButtonCommand { get; set; }
        public ICommand CreateTagButtonCommand { get; set; }
        public ICommand LogoutButtonCommand { get; set; }
        public ICommand RemoveTagButtonCommand { get; set; }
        public ICommand TodayButtonCommand { get; set; }
        public ICommand NowButtonCommand { get; set; }
        public ICommand TomorrowButtonCommand { get; set; }
        public ICommand AddDateButtonCommand { get; set; }
        public ICommand AddMeetingDateButtonCommand { get; set; }
        public ICommand MenuTaskButtonCommand { get; set; }
        public ICommand MenuBackButtonCommand { get; set; }
        public ICommand MenuMeetingButtonCommand { get; set; }
        public ICommand LogoButtonCommand { get; set; }
        private string _inviteLink;
        public string InviteLink { get { return this._inviteLink; } set { this._inviteLink = value.Trim(); } }
        public string LogoPath { get; set; }
        public string jobTitle { get; set; }
        public string meetingTitle { get; set; }
        private bool _isTask;
        public string task_id
        {
            get
            {
                return _task_id;
            }
            set
            {
                _task_id = value;
                OnPropertyChanged("isEditTask");
                OnPropertyChanged("isEdit");
            }
        }
        public string meeting_id
        {
            get
            {
                return _meeting_id;
            }
            set
            {
                _meeting_id = value;
                OnPropertyChanged("isEditMeeting");
                OnPropertyChanged("isEdit");
            }
        }
        public bool isEditTask
        {
            get
            {
                if (task_id == "")
                {
                    return false;
                }
                else
                    return true;
            }
        }
        public bool isEditMeeting
        {
            get
            {
                if (meeting_id == "")
                {
                    return false;
                }
                else
                    return true;
            }
        }
        public bool isEdit
        {
            get
            {
                if (IsTask)
                {
                    if (task_id == "")
                    {
                        return false;
                    }
                    else
                        return true;
                }
                else
                {
                    if (meeting_id == "")
                    {
                        return false;
                    }
                    else
                        return true;
                }
            }
        }
        private string _task_id;
        private string _meeting_id;
        public bool IsTask
        {
            get
            {
                return _isTask;
            }
            set
            {
                if (_isTask != value)
                {
                    
                    if (value)
                    {
                        if (main.bAllowAddTask)
                        {
                            _isTask = value;
                            this.main.clockinViewModel.IsTask = value;
                        }
                    }
                    else
                    {
                        if (main.bAllowAddMeetingRoom)
                        {
                            _isTask = value;
                            this.main.clockinViewModel.IsTask = value;
                        }
                    }
                    OnPropertyChanged("meetingMenuColor");
                    OnPropertyChanged("taskMenuColor");
                    OnPropertyChanged("taskFormVisible");
                    OnPropertyChanged("meetingFormVisible");
                    OnPropertyChanged("tagFormVisiblity");
                    OnPropertyChanged("isEdit");
                }
            }
        }
        public string startTime {
            get; 
            set;
        }
        public string endTime {
            get; 
            set;
        }
        public ObservableCollection<Tag> tags;
        private string _dueDate;
        private string _meetingDate;
        public DateTime DueDate 
        {
            get 
            {
                return DateTime.Parse(_dueDate);
            } 
            set 
            {
                _dueDate = string.Format("{0:dd MMMM yyyy}", value);
                OnPropertyChanged("todayColor");
                OnPropertyChanged("tomorrowColor");
                OnPropertyChanged("adddateColor");
            } 
        }
        public String MeetingDate
        {
            get
            {
                return _meetingDate;
            }
            set
            {
                _meetingDate = value;
                OnPropertyChanged("nowColor");
                OnPropertyChanged("addmeetingdateColor");
            }
        }
        public string tagFormVisiblity 
        {
            get; set;
        }
        public string tagToAdd { get; set; }
        public bool showCalendar { get; set; }
        public bool showCalendarMeeting { get; set; }

        public CreateViewModel()
        {
            this.main = App.Current.MainWindow as MainWindow;
            this.IsTask = true;
            this.tags = new ObservableCollection<Tag>();
            CreateTaskButtonCommand = new DWCommands(async o => await CreateTaskButtonClickAsync("createButton"));
            CreateMeetingButtonCommand = new DWCommands(async o => await CreateMeetingButtonClickAsync("createButton"));
            LogoutButtonCommand = new DWCommands(o => LogoutButtonClick("logoutButton"));
            CreateTagButtonCommand = new DWCommands(o => CreateTagButtonClick("createButton"));
            RemoveTagButtonCommand = new DWCommands(o => RemoveTagButtonClick(o));
            AddDateButtonCommand = new DWCommands(o => AddDateButtonClick());
            AddMeetingDateButtonCommand = new DWCommands(o => AddMeetingDateButtonClick());
            TomorrowButtonCommand = new DWCommands(o => TomorrowButtonClick());
            TodayButtonCommand = new DWCommands(o => TodayButtonClick());
            NowButtonCommand = new DWCommands(o => NowButtonClick());
            MenuTaskButtonCommand = new DWCommands(o => MenuTaskButtonClick());
            MenuMeetingButtonCommand = new DWCommands(o => MenuMeetingButtonClick());
            LogoButtonCommand = new DWCommands(o => Load_Click());
            MenuBackButtonCommand = new DWCommands(o => BackClockin());
            tagFormVisiblity = "Hidden";
            CreateTaskButtonEnabled = true;
            CreateMeetingButtonEnabled = true;
            this.task_id = "";
            this.meeting_id = "";
        }

        private bool _createTaskButtonEnabled;
        private bool _createMeetingButtonEnabled;
        public bool CreateTaskButtonEnabled
        {
            get
            {
                return _createTaskButtonEnabled;
            }
            set
            {
                _createTaskButtonEnabled = value;
                OnPropertyChanged("createTaskButtonEnabled");
            }
        }
        public bool CreateMeetingButtonEnabled
        {
            get
            {
                return _createMeetingButtonEnabled;
            }
            set
            {
                _createMeetingButtonEnabled = value;
                OnPropertyChanged("CreateMeetingButtonEnabled");
            }
        }

        
        public void refresh_all()
        {
            this.tags = new ObservableCollection<Tag>();
            this.task_id = "";
            this.meeting_id = "";
            OnPropertyChanged("tags");
            tagFormVisiblity = "Hidden";
            this.InviteLink = "";
            OnPropertyChanged("InviteLink");
            this.LogoPath = "";
            OnPropertyChanged("LogoPath");
            this.jobTitle = "";
            OnPropertyChanged("jobTitle");
            this.meetingTitle = "";
            OnPropertyChanged("meetingTitle");
            DueDate =  DateTime.Now;
            OnPropertyChanged("DueDate");
            this.MeetingDate = "";
            this.startTime = "12:00 AM";
            this.endTime = "11:59 PM";
            OnPropertyChanged("startTime");
            OnPropertyChanged("endTime");
        }
        private void Load_Click()
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            if (openFileDialog.ShowDialog() == true)
            {
                LogoPath = openFileDialog.FileName;
                OnPropertyChanged("LogoPath");
            }
        }
        private void BackClockin()
        {
            main.clockin();
        }
        private void MenuTaskButtonClick()
        {
            if(!isEdit)
                this.IsTask = true;
            
        }
        private void MenuMeetingButtonClick()
        {
            if (!isEdit)
                this.IsTask = false;
        }
        private void AddDateButtonClick()
        {
            showCalendar = true;
            OnPropertyChanged("showCalendar");
        }
        private void AddMeetingDateButtonClick()
        {
            showCalendarMeeting = true;
            OnPropertyChanged("showCalendarMeeting");
        }

        private void TomorrowButtonClick()
        {
            DueDate = DateTime.Now.AddDays(1);
            OnPropertyChanged("DueDate");
        }
        private void TodayButtonClick()
        {
            DueDate = DateTime.Now;
            OnPropertyChanged("DueDate");
        }
        private void NowButtonClick()
        {
            MeetingDate = string.Format("{0:dd MMMM yyyy}", DateTime.Now);
            OnPropertyChanged("MeetingDate");
        }
        private async Task CreateTaskButtonClickAsync(object sender)
        {
            try
            {
                string start_period, end_period;
                if (jobTitle == null || jobTitle == "")
                {
                    main.alertShow("Please fill in title of job");
                    return;
                }
                else if (_dueDate == null || _dueDate == "")
                {
                    main.alertShow("Please select Due Date");
                    return;
                }
                string startTimeLow = this.startTime.ToLower();
                string endTimeLow = this.endTime.ToLower();
                start_period = (this.startTime.Substring(this.startTime.Length - 2, 2)).ToLower();
                end_period = (this.endTime.Substring(this.endTime.Length - 2, 2)).ToLower();
                string tagsString = "";
                for (int i = 0; i < tags.Count; i++)
                {
                    tagsString += tags[i].name;
                    if (i != tags.Count - 1)
                    {
                        tagsString += ", ";
                    }
                }
                string weekday = "";
                int weekdayInt = (int)(DueDate.DayOfWeek);
                weekday = weekdayInt.ToString();
                this.CreateTaskButtonEnabled = false;
                await main.createTaskRequest(task_id,jobTitle, _dueDate, weekday, startTimeLow, endTimeLow, start_period, end_period, tagsString);
                this.CreateTaskButtonEnabled = true;
            }
            catch(Exception e)
            {
                main.alertShow("Something went wrong. Please try again!");
                return;
            }
        }
        private async System.Threading.Tasks.Task CreateMeetingButtonClickAsync(object sender)
        {
            if(meetingTitle == null || meetingTitle == "")
            {
                main.alertShow("Please fill in title of meeting");
                return;
            }
            else if(InviteLink == null || InviteLink == "")
            {
                main.alertShow("Please fill in invite link of meeting");
                return;
            }
            this.CreateMeetingButtonEnabled = false;
            await main.createMeetingRequest(meeting_id, meetingTitle, MeetingDate, InviteLink, LogoPath);
            this.CreateMeetingButtonEnabled = true;
        }
        private void CreateTagButtonClick(object sender)
        {
            if (tagFormVisiblity == "Hidden") tagFormVisiblity = "Visible";
            else if(tagToAdd != null && tagToAdd.Length>0)
            {
                tags.Add(new Tag(tagToAdd));
                tagFormVisiblity = "Hidden";
            }
            else
            {
                tagFormVisiblity = "Hidden";
            }
            tagToAdd = "";
            OnPropertyChanged("tagFormVisiblity");
            OnPropertyChanged("tagToAdd");
            OnPropertyChanged("Tags");
        }
        private async void LogoutButtonClick(object sender)
        {
            await main.logoutRequest();
            main.logout();
        }
        private void RemoveTagButtonClick(object sender)
        {
            foreach(Tag tag in tags)
            {
                if(tag.name == sender.ToString())
                {
                    tags.Remove(tag);
                    break;
                }
            }
            OnPropertyChanged("Tags");
        }
        private void RedirectButtonClick(object sender)
        {
            Console.Write(sender.ToString());
        }
        public ObservableCollection<Tag> Tags
        {
            get
            {
                return tags;
            }
        }
        public string meetingMenuColor
        {
            get
            {
                if (!this._isTask)
                {
                    return "#6ad1df";
                }
                else
                {
                    return "Black";
                }
            }
        }

        public string taskFormVisible
        {
            get
            {
                if (this._isTask)
                {
                    return "Visible";
                }
                else
                {
                    return "Hidden";
                }
            }
        }
        public string meetingFormVisible
        {
            get
            {
                if (!this._isTask)
                {
                    return "Visible";
                }
                else
                {
                    return "Hidden";
                }
            }
        }
        public string taskMenuColor
        {
            get
            {
                if (this._isTask)
                {
                    return "#6ad1df";
                }
                else
                {
                    return "Black";
                }
            }

        }
        public string todayColor
        {
            get
            {
                if (_dueDate == string.Format("{0:dd MMMM yyyy}", DateTime.Now))
                {
                    return "#6ad1df";
                }
                else
                {
                    return "Black";
                }
            }

        }

        public string nowColor
        {
            get
            {
                if (MeetingDate == string.Format("{0:dd MMMM yyyy}", DateTime.Now))
                {
                    return "#6ad1df";
                }
                else
                {
                    return "Black";
                }
            }

        }

        public string tomorrowColor
        {
            get
            {
                if (_dueDate == string.Format("{0:dd MMMM yyyy}", DateTime.Now.AddDays(1)))
                {
                    return "#6ad1df";
                }
                else
                {
                    return "Black";
                }
            }
        }

        public string adddateColor
        {
            get
            {
                if (_dueDate == null || _dueDate == "")
                {
                    return "Black";
                }
                else if (_dueDate == string.Format("{0:dd MMMM yyyy}", DateTime.Now))
                {
                    return "Black";
                }
                else if (_dueDate == string.Format("{0:dd MMMM yyyy}", DateTime.Now.AddDays(1)))
                {
                    return "Black";
                }
                else
                {
                    return "#6ad1df";
                }
            }
        }

        public string addmeetingdateColor
        {
            get
            {
                if (MeetingDate == null || MeetingDate == "")
                {
                    return "Black";
                }
                else if (MeetingDate == string.Format("{0:dd MMMM yyyy}", DateTime.Now))
                {
                    return "Black";
                }
                else
                {
                    return "#6ad1df";
                }
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}
