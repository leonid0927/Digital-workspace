   M S B A M L   `   `   `  ����K  GDigitalWorkspace, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null3clr-namespace:DigitalWorkspaceDigitalWorkspace  5   	   I)clr-namespace:DigitalWorkspace.ViewModelsDigitalWorkspace.ViewModels  5   	   ?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  5	   	   !    DigitalWorkspace.MainWindow   5   	   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   0localclr-namespace:DigitalWorkspace     5   	   @
viewmodels)clr-namespace:DigitalWorkspace.ViewModels     5   	   6views$clr-namespace:DigitalWorkspace.Views     5	   	     � WindowStyle$  SingleBorderWindow=�5
   	    � 
ResizeMode$ CanMinimize=�5   	    � Title$ DigitalWorkspace��5   	   $	��334��6"   $	��268��6/   
������� � 	Resources 5       �� DataType0   *DigitalWorkspace.ViewModels.LoginViewModel&    DigitalWorkspace.Views.LoginView � DataContext2   ,DigitalWorkspace.ViewModels.WelcomeViewModel(   "DigitalWorkspace.Views.WelcomeView2   ,DigitalWorkspace.ViewModels.ClockinViewModel(   "DigitalWorkspace.Views.ClockinView1   +DigitalWorkspace.ViewModels.CreateViewModel'   !DigitalWorkspace.Views.CreateView��%�  (��       5   2   *, +)(�� V     5   4   *, +)(�� �     5   4   *, +)(��     5   3   *, +)�� 5   
   loginViewTemplate��"  62   .R�5         6   �� 5      �� 5   
   welcomeViewTemplate��"  64   .R�5         6    �� 5      �� 5   
   clockinViewTemplate��"  64   .R�5         6    �� 5      �� 5   
   createViewTemplate��"  63   .R�5         6   �� 5      5      .��5      � 
�������$��0,0,0,0q�6   $	��296��6/   $	��255��6<   $��Center=�6H    � ColumnDefinitions 5   
   �� 5       $
��auto �6   �� 5!      $	��252 �6   �� 5"      $
��auto �6   .+�5$   
   �� $��0��6   $��1��6&   ��66   �� � 5%   
   -   5         �Name$ popupBox��5%      ��.   � 	StaysOpen .  	 � AllowsTransparency	 . 
 � HorizontalOffset$
 0��6^    � VerticalOffset$
 -289��6s   .��5&      � $	��252��6   $	��269��6    5'      �� 5(      $
��240* �6'   .+�5*      �� -   5         ��Name$ AlertMessageBox��5*   (   $��0��6   ���#6ad1df
�������$��Center=�6i   $��Right=�5+      $	��Top=�5,      5-      5.      5/      50      51      