using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Threading;

namespace DigitalWorkspace.Views
{
    /// <summary>
    /// Interaction logic for LoginView.xaml
    /// </summary>
    public partial class LoginView : UserControl
    {
        DispatcherTimer showPassword;
        MainWindow main;
        public LoginView()
        {
            InitializeComponent();
            main = App.Current.MainWindow as MainWindow;
            showPassword = new DispatcherTimer();
            showPassword.Interval = new TimeSpan(0, 0, 1);
            showPassword.Tick += ShowPassword;
            showPassword.Start();
        }
        private void ShowPassword(object sender, EventArgs e)
        {
            showPassword.Stop();
            if (this.DataContext != null)
            {
                setPassword(((dynamic)this.DataContext).Password);
            }
        }
        private void ForgotButton_Click(object sender, RoutedEventArgs e)
        {
            System.Diagnostics.Process.Start(this.main.serverUrl + "/forget-password");
        }
        private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
        {
            if (this.DataContext != null)
            { ((dynamic)this.DataContext).Password = ((PasswordBox)sender).Password; }
        }
        private void setPassword(string password)
        {
            pwd_text.Password = password;
        }
    }
}
