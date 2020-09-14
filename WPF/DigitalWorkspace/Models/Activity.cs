using System.Collections.Generic;

namespace DigitalWorkspace.Models
{
    public class Activity
    {
        public string name;
        public int activity_minutes;
        public float activity_percentage;
        public List<Activity> details;
        public Activity()
        {
            details = new List<Activity>();
            name = "";
            activity_minutes = 0;
            activity_percentage = 0;
        }

    }
}
