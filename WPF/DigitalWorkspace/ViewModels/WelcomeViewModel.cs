using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;

namespace DigitalWorkspace.ViewModels
{
    public class WelcomeViewModel : INotifyPropertyChanged
    {
        MainWindow main;
        public ICommand ClockinButtonCommand { get; set; }
        public ICommand LogoutButtonCommand { get; set; }
        private string _firstName;
        private string _lastName;
        public string ClockinButtonVisibility
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

        public void initView()
        {
            OnPropertyChanged("ClockinButtonVisibility");
        }
        public string FirstName
        {
            get
            {
                return _firstName;
            }
            set
            {
                this._firstName = value;
                OnPropertyChanged(Welcome);
            }
        }

        public string Welcome
        {
            get
            {
                return "Welcome, " + FirstName + ".";
            }
        }
        private bool _clockinButtonEnabled;
        public bool ClockinButtonEnabled
        {
            get
            {
                return _clockinButtonEnabled;
            }
            set
            {
                _clockinButtonEnabled = value;
                OnPropertyChanged("ClockinButtonEnabled");
            }
        }
        public string LastName
        {
            get
            {
                return _lastName;
            }
            set
            {
                this._lastName = value;
                OnPropertyChanged(Welcome);
            }
        }
        public WelcomeViewModel(MainWindow main)
        {
            this.main = main;
            ClockinButtonCommand = new DWCommands(o => ClockinButtonClick("clockinButton"));
            LogoutButtonCommand = new DWCommands(o => LogoutButtonClick("logoutButton"));
            ClockinButtonEnabled = true;
        }

        private async void ClockinButtonClick(object sender)
        {
            this.ClockinButtonEnabled = false;
            await main.clockinRequest();
            this.ClockinButtonEnabled = true;
        }

        private async void LogoutButtonClick(object sender)
        {
            await main.logoutRequest();
            main.logout();
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string name = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
        }
    }
}
