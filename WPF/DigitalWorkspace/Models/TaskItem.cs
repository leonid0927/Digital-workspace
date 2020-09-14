using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DigitalWorkspace
{
    public class TaskItem
    {
        public string title { get; set; }
        public string start_date { get; set; }
        public string end_date { get; set; }
        public string start_time { get; set; }
        public string end_time { get; set; }
        public string start_period { get; set; }
        public string end_period { get; set; }
        public string weekday { get; set; }
        public string tags { get; set; }
        public string id { get; set; }
        public bool status { get; set; }

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
        public TaskItem(string id, string title, string start_date, string start_time, string end_time, string end_date, string tags, string status)
        {
            this.id = id;
            this.title = title;
            this.start_date = start_date;
            this.tags = tags;
            this.isLast = false;
            this.status = status == "1"? true : false;
            this.end_date = end_date;
            DateTime dt = DateTime.Parse(start_time);
            this.start_time = dt.ToString("hh:mm");
            this.start_period = dt.ToString("tt");
            dt = DateTime.Parse(end_time);
            this.end_time = dt.ToString("hh:mm");
            this.end_period = dt.ToString("tt");
            this.weekday = weekday;
        }
    }

    public class Tag
    {
        public string name { get; set; }
        public Tag(string name)
        {
            this.name = name;
        }
    }
}
