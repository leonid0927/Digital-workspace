   M S B A M L   `   `   `  ����K  GDigitalWorkspace, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  5      (    "DigitalWorkspace.Views.WelcomeView   5      W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5      R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5      Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5      @d2http://schemas.microsoft.com/expression/blend/2008     5      6local$clr-namespace:DigitalWorkspace.Views     5        � 	Resources  5	         TextBoxBaseControlTemplate �� 
TargetType ��Name �� CornerRadius ��Name " PasswordBoxBaseControlTemplate  CheckBoxControlTemplate �� 
Background �� Bullet F�Name J� SnapsToDevicePixels	 �� Triggers
 P� Property P� Value �� 
TargetName �� Property �� Value��%x  &	        &	 �     &	 l    �� 5
   
   " ��6=   .R�5      �� $ Bd��5      #��z��5      ���#6ad1df#��z��5   3   $ 3��6g   ._�5      �� $ PART_ContentHost��6   5      5      �� 5   
   " G�6A   .R�5      �� $ Bd��5      #��z��5      ���#6ad1df#��z��5   3   $ 3��6g   ._�5      �� $ PART_ContentHost��6   5      5      �� 5   
   " ��6:   .R�5      �� 
 ����  5      �� 5      $ Border��6   $��10��5      $��10��5      $ 0��5      
�������$��1q�5      ���#6ad1df._�5       F� $ 	CheckMark��5"      $��10��5!      $��10��6$    .  ���#6ad1df$��1��5%      +����     	= ���- ��j ���- ��j ���j @B 	5&      5'      ._�5)      �� $��4,0,0,0q�6#   $��Center=�5*      $
��Left=�5+      ��. 5,      5-      	 5.      P� 5/      
 �@d�	IsChecked$ falseY�6/   . �50      �� $ 	CheckMark��6    � y�$ 	Collapsed=�6J   51      P� 52       6/   Z� 
 �@d�	IsChecked. �53      �� $ 	CheckMark��6    � �� ��    ��j ���j     	6D   54      56      57      .��58      � 
�������$��0,0,0,0q�6   $	��296��6/   $��Bottom=�6<    � ColumnDefinitions 59   
   �� 5:      $
��252* �6   .+�5<   
   �� 
����������#6ad1df$��7q�6�   $
��Left=�6�   $��
66,100,0,0q�6�   $	��Top=�6�   $	��122��6�   $	��122��6�   
�������$��10(�6  y�6$   �� *ClockinButtonVisibility+{�6S   �� *ClockinButtonEnabled+��6)  �� *ClockinButtonCommand+  5=       �� 
TargetType��%_   '��       �� 5>      " ��6   .�5?      ��  �@��CornerRadius$ 61��65   5@      5A      .��5B      � .+�5C      �� $��Center=�6   ���#6ad1df$��Center=�6L   $��20(�6i   
clock in6�   5D      5E      �� 5F   
   $��0q�6   
������ $��0��6>   $��0��6K   $��0,0,0,0q�6[   $
��Left=�6m   $��16��6�   $��	12,12,0,0q�6�   $	��Top=�6�   $��16��6�   ��6�   �� *LogoutButtonCommand+.��5G      �� .+�5H      �� $��/Images/AppIcon_16.png��6   5J      5K      5L      �� 5M   
   $��Center=�6,   $��center=�6Q   $��
28,38,26,0q�6n   $	��Top=�6�   $��27��6�   $	��198��6�   ���#6ad1df$��Disabled=�6�   $��12(�6�   ��6   �� *	Welcome+6�   �� 5N   
   $��Start working today.��6   $��Center=�6/   $��center=�6T   $��
59,56,55,0q�6q   $	��Top=�6�   $
��Auto��6�   $	��138��6�   ���#6ad1df$��Disabled=�6�   $��12(�6   �� 5O   
   $!��Carbonate Desktop Workspace��6   $��Center=�66   $��Center=�6Z   $
��auto��6w   $	��178��6�   ���#6ad1df$��39,244,35,26q�6�   $��12(�6�   6�   5P      5Q      