using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace DigitalWorkspace
{
    public class Auth
    {
        public int status;
        public string error;
        public Data data;
    }

    public class Data
    {
        public string authToken;
        public string track_imei_no;
        public Session session;
        public string screenshot_interval;
        public string message;
        public Dictionary<string, object> last_check_in;
        public ObservableCollection<MeetingRoom> meetingRooms;
        public ObservableCollection<TaskRoom> tasks;
        public bool bAllowAttendance;
        public bool bAllowAddMeetingRoom;
        public bool bAllowAddTask;
    }

    public class Session
    {
        public User user;
    }

    public class User
    {
        public string id;
        public string email;
        public string image;
        public string first_name;
        public string last_name;
        public string auth_token;
        public Dictionary<string, object> UserOutlet;
    }
    public class Response
    {
        public int status;
        public string error;
        public Dictionary<string, Object> data;
    }
}
