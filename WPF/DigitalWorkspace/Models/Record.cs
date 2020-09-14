using System.Collections.Generic;

namespace DigitalWorkspace.Models
{
    public class Record
    {
        public List<Activity> applist;
        public float totalMinutes;
        public Record()
        {
            applist = new List<Activity>();
            totalMinutes = 0;
        }
    }
}
