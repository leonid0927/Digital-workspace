   M S B A M L   `   `   `  ���� K  GDigitalWorkspace, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  ?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  I)clr-namespace:DigitalWorkspace.ViewModelsDigitalWorkspace.ViewModels  (    "DigitalWorkspace.Views.ClockinView   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     @d2http://schemas.microsoft.com/expression/blend/2008     6local$clr-namespace:DigitalWorkspace.Views     6views$clr-namespace:DigitalWorkspace.Views     @
viewmodels)clr-namespace:DigitalWorkspace.ViewModels     .��� 
�������$��0,0,0,0q�$	��296��$��Bottom=�  � ColumnDefinitions  ��  � RowDefinitions �� $	��38* ��� $
��216* ��� $	��42* �.+��� -    ��Name$ 
headerGrid��$��0��$��0�����#F3F3F3�� -   $ mainGrid��$��1��$��0���� -   $ 
footerGrid��$��2��$��0�����#F3F3F3�� $��0q�
������ $��0��$��0��$��0,0,0,0q�$
��Left=�$��16��$��	12,12,0,0q�$	��Top=�$��16������ *LogoutButtonCommand+.���� .+��� $��/Images/AppIcon_16.png���� $��0��$��0��$��Tasks��
������ $��13(�$��55��$��33��$	��Top=�$��0,0,0,1q�$��Right=�$��	0,4,133,0q����� *TasksMenuButtonCommand+���� *getTasksMenuColor+ �� UpdateSourceTrigger$ PropertyChanged=����� *getTasksMenuBottomColor+$ PropertyChanged=��� $��0��$��Meetings��
������ $��13(�$��63��$��33��$	��Top=�$��0,0,0,1q�$��Right=�$��0,4,55,0q����� *MeetingsMenuButtonCommand+���� *getMeetingsMenuColor+$ PropertyChanged=����� *getMeetingsMenuBottomColor+$ PropertyChanged=��� -    ��Name$ taskListView��$��1��
������ $��0q� �� SelectionMode$ Single=�y��� *getTasksVisibility+$ PropertyChanged=����� *	TaskItems+$ PropertyChanged=� �� SelectedItem �� *SelectedTask+ � 	Resources    SelectedTemplate �� 
TargetType	 �� ElementName
 �� Path �� 
TargetType �� Property �� Value �� Triggers ]� 
Conditions �� Property �� Value��%�  &	        '��     7   �� " ��.R��   �� $��32 ��� $	��180 ��� $��20 �.+��� $��0�����#6AD1DF$��
0, 0, 0, 1q�$��12,0,0,0q�y��� *
visibility+�� $��1�����#6AD1DF$��
0, 0, 0, 1q�y��� *
visibility+�� $��2�����#6AD1DF$��
0, 0, 0, 1q�y��� *
visibility+�� $%��/Images/icon_time-countdown.png��$��	15,21,0,0q�$
��Left=�$	��top=�$��18���� $��1�����#6AD1DF$	��170��$
��auto��$
��Left=�$	��top=�$��12(�$��2,8,0,0q�.���� $��WordEllipsis=����� *title+�� $��1�����#6AD1DF$��11(�$��	3,26,0,12q�.���� $��WordEllipsis=����� *
start_date+�� $��1�����#AFAFAF$��11(�$��
69,26,0,12q�.���� $��WordEllipsis=����� *tags+�� $��2��$��2,2,1,0q�$
��Left=�
������ $��0q����#6AD1DF$��14��$��0,24,0,0q�$	��Top=�$��14������ $	 taskListView��$%
 DataContext.SelectButtonCommand����� *link+ ���� '��       " ��.���  �@��CornerRadius$	 6.5��.���� .+��� $��0,0,0,0q�$��/Images/Path 373@2x.png���� " ��.�-   ��  � �� �� " ��.R��   �� $��32 ��� $	��180 ��� $��20 �.+��� $��0�����#6AD1DF$��
0, 0, 0, 1q�$��12,0,0,0q�y��� *
visibility+�� $��1�����#6AD1DF$��
0, 0, 0, 1q�y��� *
visibility+�� $��2�����#6AD1DF$��
0, 0, 0, 1q�y��� *
visibility+�� $%��/Images/icon_time-countdown.png��$��	15,21,0,0q�$
��Left=�$	��top=�$��18���� $��1��$	��170��$
��auto��$
��Left=�$	��top=�$��12(�$��2,8,0,0q�.���� $��WordEllipsis=����� *title+�� $��1�����#6AD1DF$��11(�$��	3,26,0,12q�.���� $��WordEllipsis=����� *
start_date+�� $��1�����#AFAFAF$��11(�$��
69,26,0,12q�.���� $��WordEllipsis=����� *tags+�� $��2��$��2,2,1,0q�$
��Left=�
������ $��0q����#6AD1DF$��14��$��0,24,0,0q�$	��Top=�$��14������ $	 taskListView��$%
 DataContext.SelectButtonCommand����� *id+ ���� '��       " ��.���  �@��CornerRadius$	 6.5��.���� .+��� $��0,0,0,0q�$��/Images/Path 373@2x.png�� ]�  ��  �@��
IsSelected . ./���  � ��8   �� -   $ meetingListview��$��1��
������ $��0q�$ Single=����� *MeetingItems+y��� *getMeetingsVisibility+$ PropertyChanged=� �� *SelectedMeeting+  J� Clip �� RadiusX �� RadiusY �� Rect��%e
  &	        '�� �    7   �� " ��.R��   �� $��32 ��� $	��150 ��� $	��10* �.+��� $��0�����#6AD1DF$��
0, 0, 0, 1q�$��12,0,0,0q��� $��1�����#6AD1DF$��
0, 0, 0, 1q��� $��2�����#6AD1DF$��
0, 0, 0, 1q��� $��	12,21,0,0q�$
��Fill=�$
��Left=�$	��top=�$��20��$��20������ *image+ �� $ 10Q�$ 10Q�$ 	0,0,20,20��� $��1��$
��auto�����#6AD1DF$
��auto��$
��Left=�$	��top=�$��2,16,0,0q�.���� $��WordEllipsis=����� *title+�� $��1�����#6AD1DF$��11(�$��3,35,0,0q����� *
start_time+�� $��1�����#AFAFAF$��11(�$��	68,35,0,0q����� *
platform+�� $��2��$��0,0,0,0q�$
��Left=�
������ $��0q�
������ $��14��$��	12,23,0,0q�$	��Top=�$��14������ $	 meetingListview��$,
 &DataContext.SaveClipboardButtonCommand����� *link+ ���� '��       " ��.���  �@��CornerRadius$	 6.5��.���� .+��� $��0,0,0,0q�$��/Images/clip.png���� $��2��$��0q�
������ ���#6AD1DF$��14��$��14��$��24,0,0,0q����� $	 meetingListview��$'
 !DataContext.RedirectButtonCommand����� *link+ ���� '��       " ��.���  �@��CornerRadius$	 6.5��.���� .+��� $��2,0,0,0q�$��/Images/icon_left_2x.png��$��8��$��9���� " ��.�-   ��  � �� �� " ��.R��   �� $��32 ��� $	��150 ��� $	��10* �.+��� $��0�����#6AD1DF$��
0, 0, 0, 1q�$��12,0,0,0q��� $��1�����#6AD1DF$��
0, 0, 0, 1q��� $��2�����#6AD1DF$��
0, 0, 0, 1q��� $��	12,21,0,0q�$
��Fill=�$
��Left=�$	��top=�$��20��$��20������ *image+ �� $ 10Q�$ 10Q�$ 	0,0,20,20��� $��1��$
��auto��$
��auto��$
��Left=�$	��top=�$��2,16,0,0q�.���� $��WordEllipsis=����� *title+�� $��1�����#6AD1DF$��11(�$��3,35,0,0q����� *
start_time+�� $��1�����#AFAFAF$��11(�$��	68,35,0,0q����� *
platform+�� $��2��$��0,0,0,0q�$
��Left=�
������ $��0q�
������ $��14��$��	12,23,0,0q�$	��Top=�$��14������ $	 meetingListview��$,
 &DataContext.SaveClipboardButtonCommand����� *link+ ���� '��       " ��.���  �@��CornerRadius$	 6.5��.���� .+��� $��0,0,0,0q�$��/Images/clip.png���� $��2��$��0q�
������ ���#6AD1DF$��14��$��14��$��24,0,0,0q����� $	 meetingListview��$'
 !DataContext.RedirectButtonCommand����� *link+ ���� '��       " ��.���  �@��CornerRadius$	 6.5��.���� .+��� $��2,0,0,0q�$��/Images/icon_left_2x.png��$��8��$��9�� ]�  ��  �@��
IsSelected . ./���  � ��8   �� $��1��$��Center=�$��Center=�$ ��Currently No task for you?��y��� *emptyTaskVisibility+�� $��1��$��Center=�$��Center=�$#��Currently No meeting for you?��y��� *emptyMeetingVisibility+�� $��0q����#F3F3F3$��3q�$��2��$��0��$
��Left=�$��26��$��9,9,0,0q�$	��Top=�$��26��{��� *EditbuttonEnabled+y��� *manageTaskVisibility+���� *EditButtonCommand+.���� .+��� $��16��$��16������ *EditbuttonImage+ ��%9   '��       �� " ��.���  �@��CornerRadius$ 3���� $��2��$��0��
�������
�������$
��Left=�$��45,9,0,0q�$	��Top=�$	��161��$��26�����#6ad1df$��10(�y��� *VisibilityClockoutButton+{��� *ClockoutButtonEnable+���� *ClockoutButtonCommand+ ��%9   '��       �� " ��.���  �@��CornerRadius$ 3��.��� .+��� $��Center=�$��Center=�$��10(�	CLOCK OUT�� $��2�����#6ad1df$��0,0,0,0q����#6ad1df$
��Left=�$��	217,9,0,0q�$	��Top=�$��26��$��26��
�������$��10(�y��� *manageTaskVisibility+���� *CreateButtonCommand+ ��%9   '��       �� " ��.���  �@��CornerRadius$ 3��.��� .+��� $��Center=�$��Right=�$��20(�$��0,0,0,3q�+