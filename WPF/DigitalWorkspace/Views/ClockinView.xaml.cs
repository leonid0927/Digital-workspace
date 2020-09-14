using System.Windows.Controls;
using System.Windows.Input;

namespace DigitalWorkspace.Views
{
    /// <summary>
    /// Interaction logic for ClockinView.xaml
    /// </summary>
    public partial class ClockinView : UserControl
    {
        public ClockinView()
        {
            InitializeComponent();
        }
        private void MeetingListViewItem_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            var item = sender as ListViewItem;
            if (item != null && item.IsSelected)
            {
                meetingListview.SelectedItem = null;
                //Do your stuff
            }
        }
        private void TaskListViewItem_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            var item = sender as ListViewItem;
            if (item != null && item.IsSelected)
            {
                taskListView.SelectedItem = null;
                //Do your stuff
            }
        }
    }
}
