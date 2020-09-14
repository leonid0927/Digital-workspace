using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace DigitalWorkspace
{
    /// <summary>
    /// Interaction logic for ControlPanel.xaml
    /// </summary>
    public partial class ControlPanel : Window
    {
        MainWindow login;
        public ControlPanel(MainWindow login)
        {
            InitializeComponent();
            this.login = login;
        }

        private void Window_Closed(object sender, EventArgs e)
        {
            this.login.Close();
        }
    }
}
