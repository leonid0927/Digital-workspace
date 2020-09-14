using DigitalWorkspace.Models;
using System.Collections.Generic;
using System.ComponentModel;
using System.Threading.Tasks;
using System.Windows.Input;

namespace DigitalWorkspace.ViewModels
{
    public class LoginViewModel : INotifyPropertyChanged
    {
        MainWindow main;
        private bool _canLogin;
        public bool canLogin {
            get
            {
                return _canLogin;
            }
            set 
            {
                _canLogin = value;
                OnPropertyChanged("canLogin");
            }
        }
        public ICommand LoginButtonCommand { get; set; }
        public bool isRemembered
        {
            get; set;
        }
        public LoginViewModel(MainWindow main)
        {
            //this.Email = "chandni@sodainmind.com";
            this.Email = "";
            this.main = main;
            this.canLogin = true;
            LoginButtonCommand = new DWCommands(o => LoginButtonClickAsync("loginButton"));
            Credential remembered = new Credential();
            remembered = main.DeSerializeObject<Credential>(main.capture_directory + "\\remembered.xml");
            if (remembered != null && remembered.email != "")
            {
                isRemembered = true;
                Email = remembered.email;
                Password = remembered.password;
            }
            else
            {
                isRemembered = false;
            }
        }


        private async Task LoginButtonClickAsync(object sender)
        {
            string email_phone = this.Email;
            string pwd = this.Password;
            if (isRemembered)
            {
                Credential remembered = new Credential();
                remembered.password = pwd;
                remembered.email = email_phone;
                main.SerializeObject(remembered, main.capture_directory + "\\remembered.xml");
            }
            else
            {
                Credential remembered = new Credential();
                remembered.password = "";
                remembered.email = "";
                main.SerializeObject(remembered, main.capture_directory + "\\remembered.xml");
            }
            if (email_phone == null || email_phone == "")
            {
                this.main.alertShow("Provide valid a email address");
            }
            else if(pwd == null || pwd == "")
            {
                this.main.alertShow("Provide a password");
            }
            else
            {
                this.canLogin = false;
                await main.loginRequest(email_phone, pwd);
                this.canLogin = true;
            }
        }
        public void clearPassword()
        {
            this.Password = "";
        }
        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private string _email;
        public string Email
        {
            get
            {
                return _email;
            }
            set
            {
                if(value != _email)
                {
                    _email = value;
                    OnPropertyChanged("Email");
                }
            }
        }
        private string _password;
        public string Password {
            get
            {
                return _password;
            }
            set
            {
                if (value != _password)
                {
                    _password = value;
                    OnPropertyChanged("Password");
                }
            }
        }
    }
}
