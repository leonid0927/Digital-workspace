   M S B A M L   `   `   `  ���� K  GDigitalWorkspace, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  ?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  I)clr-namespace:DigitalWorkspace.ViewModelsDigitalWorkspace.ViewModels  X TXceed.Wpf.Toolkit, Version=3.8.0.0, Culture=neutral, PublicKeyToken=3e4669d2f30244f4P:clr-namespace:Xceed.Wpf.Toolkit;assembly=Xceed.Wpf.ToolkitXceed.Wpf.Toolkit '    !DigitalWorkspace.Views.CreateView   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     @d2http://schemas.microsoft.com/expression/blend/2008     6local$clr-namespace:DigitalWorkspace.Views     6views$clr-namespace:DigitalWorkspace.Views     @
viewmodels)clr-namespace:DigitalWorkspace.ViewModels     NwpfTool:clr-namespace:Xceed.Wpf.Toolkit;assembly=Xceed.Wpf.Toolkit     .��� 
�������$��0,0,0,0q�$	��296��$��Bottom=�  � RowDefinitions  �� $	��38* ��� $	��61* ��� $
��197* �.+��� -    ��Name$ 
headerGrid��$��0��$��0�����#F3F3F3�� -   $ mainGrid��$��1��$��0��$��	0,0,0,135q��� -   $ 
footerGrid��$��2��$��0���� $��0q�
������ $��0��$��0��$��0,0,0,0q�$
��Left=�$��16��$��	12,12,0,0q�$	��Top=�$��16������ *LogoutButtonCommand+.���� .+��� $��/Images/AppIcon_16.png���� $��Center=�$��0��$��0��$
��Back�����#6ad1df
������ 
������ $��12(�$��37��$��20��$	��Top=�$��Right=�$��	0,10,10,0q����� *MenuBackButtonCommand+�� $��1��$��0��$��70��$��14,15,168,23q�����  �� 
TargetType" �� �� Triggers ��  �� Binding �� *isEdit+ �� Value True.a���  �� Property � �� �� Value$ 	Edit a...����  �� *isEdit+	 False.a���  � ��$ Create a...���� $��Right=�$��0��$��1��$��Tasks��
������ 
������ $��11(�$��37��$��20��$	��Top=�$��Right=�$��
0,41,196,0q����� *MenuTaskButtonCommand+���� *taskMenuColor+�� $��Right=�$��1��$��Meetings��
������ 
������ $��11(�$��56��$��20��$	��Top=�$��Right=�$��
0,41,124,0q����� *MenuMeetingButtonCommand+���� *meetingMenuColor+A� $��0��$��1�����#6ad1df$
��Left=�$��4�����#6ad1df$��4��$��	21,50,0,7q�A� $��0��$��1�����#6ad1df$
��Left=�$��4�����#6ad1df$��4��$��	74,50,0,7q��� $��0��$��2��y��� *taskFormVisible+.+��   �� $��0 ��� $��0 ��� $
��197* �.+��� -    ��Name$ SearchTermTextBox��$��0��$��2��$	��204�����#6ad1df$��0,0,0,1q�$��Center=�$
��Left=�$��20,21,0,160q����� *
jobTitle+�� $��0��$��2��	 J� IsHitTestVisible	 .  $��	Job Title��$��Center=�$
��Left=�$��22,21,0,160q����#6ad1df
 J� Opacity$	
 .43Q�$	��202������ " ��.���  � y�$ 	Collapsed=� ��  �� *Text+ �� ElementName$ SearchTermTextBox��  .a���  � y�$ Visible=��� $��2��$
��Tags��$
��Auto��$��10(�$
��auto��$��22,53,198,116q��� -    ��Name$ 	tagScroll��$��2��$��Hidden=�$��Hidden=�$��50,54,67,120q�.���� -    ��Name$ tagList��
������ $��0q�$��Disabled=� �� SelectionMode$ Extended=�$��23��$	��Top=����� *Tags+ �� UpdateSourceTrigger$ PropertyChanged=� � 	Resources  �� 
TargetType � ColumnDefinitions �� Mode��%v  '��       �� " ��.���  � �� �� " ��.R��  �� $
��auto �.+��� $��0�����	#2D3AABCD$��0q�$
��10,0q�$
��Left=�$��0,0,3,0q�$��10(�$
��Auto��$��13��$
��Bold"����� *$"DataContext.RemoveTagButtonCommand+$ tagList������ *name+���� *name+$ TwoWay=� ���� '��       " ��.���  �@��CornerRadius$	 6.5������ .R���  �� Orientation$ 
Horizontal=��� $��2,3,2,2q�$��10(�$��2�����#6ad1df$��1q�$��50,56,67,123q����� *
tagToAdd+y��� *tagFormVisiblity+�� $��2�����	#2D3AABCD$��0q�$��10, -7, 10, 0q�$
��Left=�$��192,59,0,127q�$��+��$��16(�$
��Auto��$��13��$
��Bold"����� *CreateTagButtonCommand+ ��%;   '��       �� " ��.���  �@��CornerRadius$	 6.5���� $��2��$	��Due��$
��Auto��$��10(�$
��auto��$��22,86,198,70q��� $��Right=�$��0��$��2��$��Today��
������ 
������ $��10(�$��36��$��20��$	��Top=�$��Right=�$��
0,87,160,0q����� *TodayButtonCommand+���� *
todayColor+�� $��Right=�$��2��$��Tomorrow��
������ 
������ $��10(�$��54��$��20��$	��Top=�$��Right=�$��	0,87,88,0q����� *TomorrowButtonCommand+���� *tomorrowColor+A� $��0��$��2�����#6ad1df$
��Left=�$��4�����#6ad1df$��4��$��
58,96,0,99q�A� $��0��$��2�����#6ad1df$
��Left=�$��4�����#6ad1df$��4��$��111,96,0,99q��� -    ��Name$ addDateButton��$��Right=�$��2��$��Add date��
������ 
������ $��10(�$��53��$��20��$	��Top=�$��Right=�$��	0,87,24,0q����� *adddateColor+���� *AddDateButtonCommand+�� $��0��$��2��$��7��$��0,0,0,0q�
������ $��0q�$��176,91,69,92q� J� RenderTransformOrigin$ 2.857,0.562&����� *AddDateButtonCommand+.���� .+��� $"��/Images/Icon Calendar@2x.png���  � 	StaysOpen .   � AllowsTransparency .  � HorizontalOffset$	 100�� � VerticalOffset$	 -70������ *showCalendar+.��&   System.Windows.Controls.Calendar  -     Name$ CalendarControl��$��Center=�$��Center=�   SelectedDate �� *	DueDate+�� $��2��$��0��$��0q�$
��Left=�$��
49,156,0,0q�$	��Top=�$	��157��$��23��
����������#6ad1df$��10(����� *CreateTaskButtonCommand+{��� *CreateTaskButtonEnabled+ ��%<   '��       �� " ��.���  �@��CornerRadius$
 11.5��.��� .+��� $��Center=�$��Center=�$��12(����� " ��.���  � �� �� *	FalseText+ ��  �� *
isEditTask+	 False.a���  � ��$ CREATE TASK����  �� *
isEditTask+ True.a���  � ��$ UPDATE TASK���� $��0q�$��2��$��
Start Time��$
��Auto��$��10(�$
��auto��$��28,120,175,50q�&   Xceed.Wpf.Toolkit.DateTimeUpDown  -	     Name$ startTimetext��$��0��$��2��   Format$ Custom=�$��48���  �Xceed.Wpf.Toolkit.Primitives.UpDownBase`1[[System.Nullable`1[[System.DateTime, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]], mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]   ShowButtonSpinner .      DefaultValue$  12:00 AMX�%!   DisplayDefaultValueOnEmptyText! . "   FormatString$" hh:mm tt�����#6ad1df$��10(�$��16��$��0,0,0,1q�$��Center=�$
��Left=�$��74,119,0,63q�,  &Xceed.Wpf.Toolkit.Primitives.InputBase#   Text# �� *	startTime+�� $��0q�$��2��$��End Time��$
��Auto��$��10(�$
��auto��$��127,120,80,50q�  -
   $ endTimetext��$��0��$��2��$ Custom=�$��48�� .  $  11:59 PMX�! . $" hh:mm tt�����#6ad1df$��10(�$��0,0,0,1q�$��Center=�$
��Left=�$��170,119,0,63q�$��16��# �� *	endTime+�� $��0��$��2��y��� *meetingFormVisible+.+��   �� $��0 ��� $��0 ��� $
��177* �.+��� -   $ meetingTitleText��$��0��$��2��$	��204�����#6ad1df$��0,0,0,1q�$��Center=�$
��Left=�$��20,19,0,142q����� *meetingTitle+�� $��0��$��2��	 .  $��Meeting Title��$��Center=�$
��Left=�$��22,19,0,143q����#6ad1df$	
 .43Q�$	��202������ " ��.���  � y�$ 	Collapsed=� ��  �� *Text+$ meetingTitleText��  .a���  � y�$ Visible=��  .   . $ 65��$	 -90������ *showCalendarMeeting+.��  $��Center=�$��Center=� �� *MeetingDate+�� $��0,0,0,0q�$��2��$��Invite link��$
��Auto��$��10(�$
��auto��$��27,79,183,89q��� -   $ 
inviteLink��$��0��$��2��$	��139��$��10(�$��0q�$��Center=�$
��Left=����	#203AABCD$��
74,80,0,90q�$��12��$��3,0,5,0q����� *
InviteLink+.�� ��%9   '��       �� " ��.���  �@��CornerRadius$ 6��.��� $��3��  �� $��0 ��� $��0 ��� $
��177* �.+��� -   $ meetingTitle��$��0��$��2��$	��204�����#6ad1df$��0,0,0,1q�$��Center=�$
��Left=�$��20,19,0,142q����� *meetingTitle+�� $��0��$��2��	 .  $��Meeting Title��$��Center=�$
��Left=�$��22,19,0,143q����#6ad1df$	
 .43Q�$	��202������ " ��.���  � y�$ 	Collapsed=� ��  �� *Text+$ meetingTitle��  .a���  � y�$ Visible=��  .   . $ 65��$	 -90������ *showCalendarMeeting+.��  $��Center=�$��Center=� �� *MeetingDate+�� $��2��$��0��$��0q�$
��Left=�$��
49,156,0,0q�$	��Top=�$	��157��$��23��
����������#6ad1df$��10(����� *CreateMeetingButtonCommand+{��� *CreateMeetingButtonEnabled+ ��%<   '��       �� " ��.���  �@��CornerRadius$
 11.5��.��� .+��� $��Center=�$��Center=�$��12(����� " ��.���  � �� �� *	FalseText+ ��  �� *isEditMeeting+	 False.a���  � ��$ CREATE MEETING����  �� *isEditMeeting+ True.a���  � ��$ UPDATE MEETING���� $��2��$
��Logo��$
��Auto��$��10(�$
��auto��$��22,105,183,51q��� -   $ ��Name$$ logoPath��$��0��$��2��$	��139��$��10(�$��0q�$��Center=�$
��Left=����	#203AABCD$��5,0,5,0q�$��74,111,0,58q�$��13������ *
LogoPath+ ��%9   '��       �� " ��.���  �@��CornerRadius$ 6��% J� InputBindings% d� & d� MouseAction$& 	LeftClicke�' �� Command' �� ( �� Path$( LogoButtonCommand�