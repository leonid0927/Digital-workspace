   M S B A M L   `   `   `  ���� K  GDigitalWorkspace, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:DigitalWorkspace.ViewsDigitalWorkspace.Views  &     DigitalWorkspace.Views.LoginView   W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     @d2http://schemas.microsoft.com/expression/blend/2008     6local$clr-namespace:DigitalWorkspace.Views       � 	Resources     TextBoxBaseControlTemplate �� 
TargetType ��Name �� CornerRadius ��Name " PasswordBoxBaseControlTemplate  CheckBoxControlTemplate �� 
Background �� Bullet F�Name J� SnapsToDevicePixels	 �� Triggers
 P� Property P� Value �� 
TargetName �� Property �� Value��%�  &	        &	 _     &	 �     �� " ��.R��� $ Bd��#��z�����#6ad1df#��z��$ 3��._��� $ PART_ContentHost���� " G�.R��� $ Bd��#��z�����#6ad1df#��z��$ 3��._��� $ PART_ContentHost���� " ��.R��� 
 ����  �� $ Border��$��10��$��10��$ 0��
�������$��1q����#6ad1df._�F� $ 	CheckMark��$��10��$��10�� .  ���#6ad1df$��1��+����     	= ���- ��j ���- ��j ���j @B 	._��� $��4,0,0,0q�$��Center=�$
��Left=���. 	 P� 
 �@d�	IsChecked$ falseY�. ��� $ 	CheckMark�� � y�$ 	Collapsed=�P�  Z� 
 �@d�	IsChecked. ��� $ 	CheckMark�� � �� ��    ��j ���j     	�� $ Border�� � �� �#6ad1df�� $ Border�� � ��
 �����.��� 
�������$��0,0,0,0q�$	��296��$	��252��$��Bottom=� � ColumnDefinitions �� $	��252 �.+��� -   $��
email_text��#��[  $
��Left=�$��24��$��1q�
�������
������ ���	#FF434F5B$��12(�$��
42,106,0,0q�$��3,3,3,3q�$	��Top=�$	��173������ *Email+G� -   $��pwd_text��#��[ $
��Left=�$��24��$��1q�
�������
������ ���	#FF434F5B$��10(�$��
42,155,0,0q�$��3,4,3,2q�$	��Top=�$	��173�� J� RenderTransformOrigin$ 0.506,-0.05&��� ���#6ad1df���#6ad1df$
��Left=�$��
44,215,0,0q�$	��Top=�$	��171��$��26��
�������$��10(�{��� *
canLogin+����  �� Path$ LoginButtonCommand�����  �� ElementName$ pwd_text��   �� 
TargetType��%9   '��       �� " ��.���  �@��CornerRadius$ 3��.��� .+��� $��Center=�$��Center=�$��12(�$��0,1,0,-1q�LOG IN�� $��/Images/TitleLogo.png��$��40,43,35,224q��� $��E-mail�����	#FF434F5B$
��Left=�$��	37,84,0,0q�$	��Top=�$��12(��� $��Password�����	#FF434F5B$
��Left=�$��
38,132,0,0q�$	��Top=�$��12(��� $��Remember me��#��[ ���	#FF434F5B$
��Left=�$��
44,189,0,0q�$	��Top=�$��12(�$ 0.514,-0.083&�$��96�� d� 	IsChecked �� *isRemembered+�� -   ���	#FF434F5B$��Center=�$��Forgot Password?��$��73,250,67,22q� � Cursor$
 Hand��$��14(����� " ��.R��� �� ���� " ��.���  � ��
 ��  � �� Triggers P� 
 �@J�IsMouseOver . . ���  � ��
 �  ��