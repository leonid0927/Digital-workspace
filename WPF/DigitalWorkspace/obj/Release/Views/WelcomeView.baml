   M S B A M L   `   `   `  ���� K  GDigitalWorkspace, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  (    "DigitalWorkspace.Views.WelcomeView   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     @d2http://schemas.microsoft.com/expression/blend/2008     6local$clr-namespace:DigitalWorkspace.Views       � 	Resources     TextBoxBaseControlTemplate �� 
TargetType ��Name �� CornerRadius ��Name " PasswordBoxBaseControlTemplate  CheckBoxControlTemplate �� 
Background �� Bullet F�Name J� SnapsToDevicePixels	 �� Triggers
 P� Property P� Value �� 
TargetName �� Property �� Value��%�  &	        &	 _     &	 �     �� " ��.R��� $ Bd��#��z�����#6ad1df#��z��$ 3��._��� $ PART_ContentHost���� " G�.R��� $ Bd��#��z�����#6ad1df#��z��$ 3��._��� $ PART_ContentHost���� " ��.R��� 
 ����  �� $ Border��$��10��$��10��$ 0��
�������$��1q����#6ad1df._�F� $ 	CheckMark��$��10��$��10�� .  ���#6ad1df$��1��+����     	= ���- ��j ���- ��j ���j @B 	._��� $��4,0,0,0q�$��Center=�$
��Left=���. 	 P� 
 �@d�	IsChecked$ falseY�. ��� $ 	CheckMark�� � y�$ 	Collapsed=�P�  Z� 
 �@d�	IsChecked. ��� $ 	CheckMark�� � �� ��    ��j ���j     	.��� 
�������$��0,0,0,0q�$	��296��$��Bottom=� � ColumnDefinitions �� $
��252* �.+��� 
����������#6ad1df$��7q�$
��Left=�$��
66,100,0,0q�$	��Top=�$	��122��$	��122��
�������$��10(�y��� *ClockinButtonVisibility+{��� *ClockinButtonEnabled+���� *ClockinButtonCommand+   �� 
TargetType��%:   '��       �� " ��.���  �@��CornerRadius$ 61��.��� .+��� $��Center=����#6ad1df$��Center=�$��20(�
clock in�� $��0q�
������ $��0��$��0��$��0,0,0,0q�$
��Left=�$��16��$��	12,12,0,0q�$	��Top=�$��16������ *LogoutButtonCommand+.���� .+��� $��/Images/AppIcon_16.png���� $��Center=�$��center=�$��
28,38,26,0q�$	��Top=�$��27��$	��198�����#6ad1df$��Disabled=�$��12(����� *	Welcome+�� $��Start working today.��$��Center=�$��center=�$��
59,56,55,0q�$	��Top=�$
��Auto��$	��138�����#6ad1df$��Disabled=�$��12(��� $!��Carbonate Desktop Workspace��$��Center=�$��Center=�$
��auto��$	��178�����#6ad1df$��39,244,35,26q�$��12(�