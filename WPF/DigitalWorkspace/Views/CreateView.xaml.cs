using Microsoft.Win32;
using System.IO;
using System.Windows.Controls;
using System.Windows.Input;

namespace DigitalWorkspace.Views
{
    /// <summary>
    /// Interaction logic for ClockinView.xaml
    /// </summary>
    public partial class CreateView : UserControl
    {
        public CreateView()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, System.Windows.RoutedEventArgs e)
        {

        }

        private void logoPath_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
        private void ScrollViewer_PreviewMouseWheel(object sender, MouseWheelEventArgs e)
        {
            if (e.Delta < 0) // wheel down
            {
                if (tagScroll.HorizontalOffset + e.Delta > 0)
                {
                    tagScroll.ScrollToHorizontalOffset(tagScroll.HorizontalOffset + e.Delta);
                }
                else
                {
                    tagScroll.ScrollToLeftEnd();
                }
            }
            else //wheel up
            {
                if (tagScroll.ExtentWidth > tagScroll.HorizontalOffset + e.Delta)
                {
                    tagScroll.ScrollToHorizontalOffset(tagScroll.HorizontalOffset + e.Delta);
                }
                else
                {
                    tagScroll.ScrollToRightEnd();
                }
            }

        }

        private void logoPath_IsEnabledChanged(object sender, System.Windows.DependencyPropertyChangedEventArgs e)
        {

        }
    }
}
