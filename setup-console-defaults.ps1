#set the default console settings
Set-ItemProperty -path HKCU:\Console -name QuickEdit -value 1
Set-ItemProperty -path HKCU:\Console -name FaceName -value Consolas
Set-ItemProperty -path HKCU:\Console -name FontFamily -value 54
Set-ItemProperty -path HKCU:\Console -name FontSize -value 0x100000
                                          #ScreenBufferSize 120 w x 3000 h
Set-ItemProperty -path HKCU:\Console -name ScreenBufferSize 0xbb80078
                                          #WindowSize 120 w x 40 h
Set-ItemProperty -path HKCU:\Console -name WindowSize 0x280078

#delete all the exe specific console settings
dir hkcu:\console | %{del -path $_.pspath}