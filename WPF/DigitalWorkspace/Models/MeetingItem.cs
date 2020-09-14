using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DigitalWorkspace
{
    public class MeetingItem
    {
        public string title { get; set; }
        public string start_time { get; set; }
        public string platform { get; set; }
        public string image { get; set; }
        public string link { get; set; }
        public string id { get; set; }
        public bool isLast
        {
            set
            {
                if (value)
                {
                    visibility = "Visible";
                }
                else
                {
                    visibility = "Visible";
                }
            }
        }
        public string visibility { get; set; }
        public MeetingItem(string id, string title, string start_time, string platform, string link, string image)
        {
            this.title = title;
            this.start_time = start_time;
            this.platform = platform;
            this.link = link;
            this.image = image;
            this.isLast = false;
            this.id = id;
        }
    }
}
