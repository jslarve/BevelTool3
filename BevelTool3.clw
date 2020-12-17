  PROGRAM
!
! The Bevel Tool III

!MIT License
!
!Copyright (c) 2020 Jeff Slarve
!
!Permission is hereby granted, free of charge, to any person obtaining a copy
!of this software and associated documentation files (the "Software"), to deal
!in the Software without restriction, including without limitation the rights
!to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
!copies of the Software, and to permit persons to whom the Software is
!furnished to do so, subject to the following conditions:
!
!The above copyright notice and this permission notice shall be included in all
!copies or substantial portions of the Software.
!
!THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
!IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
!FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
!AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
!LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
!OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
!SOFTWARE.
!

                    MAP
                        CalculateStyle  !Roll up the bits of all of the sides into BevelStyle
                        FormatBevelDec  !Format bevel modifier (for Clarion window/report)
                        SyncControls(LONG pLoadStyle=0)
                        Hex(LONG),STRING
                    END


RegKey              EQUATE('SOFTWARE\JSSoftware\TheBevelTool')
HideButtons         BYTE
BevelStyle          USHORT
BevelInner          SHORT
BevelOuter          SHORT
HexStyle            STRING(12)
BevelDec            STRING(40)

Bevel:Left:Outer    EQUATE(1) !Defining explicitly (instead of ITEMIZE) because these will be used as array element designators
Bevel:Left:Inner    EQUATE(2)
Bevel:Top:Outer     EQUATE(3)
Bevel:Top:Inner     EQUATE(4)
Bevel:Right:Outer   EQUATE(5)
Bevel:Right:Inner   EQUATE(6)
Bevel:Bottom:Outer  EQUATE(7)
Bevel:Bottom:Inner  EQUATE(8)

BevelSides          USHORT,DIM(8) !The values of all of the sides (plus inner/outer)
FillColor           LONG

Window              WINDOW('The Bevel Tool III'),AT(,,436,311),CENTER,GRAY,SYSTEM,ICON('bt.ico'), |
                        FONT('Segoe UI',9,,FONT:regular),DOUBLE
                        PROMPT('Bevel &Style:'),AT(5,6),USE(?BevelStylePrompt)
                        SPIN(@n12),AT(51,4,153,12),USE(BevelStyle),IMM,RANGE(0,65535),STEP(1)
                        PROMPT('&Declaration:'),AT(5,20),USE(?Prompt4)
                        TEXT,AT(51,20,153,12),USE(BevelDec),SKIP,FONT('Courier New',9,,FONT:regular), |
                            COLOR(COLOR:BTNFACE),CURSOR(CURSOR:IBeam),READONLY,SINGLE
                        PROMPT('&Outer:'),AT(217,5),USE(?BevelOuterPrompt)
                        SPIN(@n-4),AT(245,4,48,12),USE(BevelOuter),IMM,RANGE(-255,255),STEP(1)
                        PROMPT('&Inner:'),AT(217,22),USE(?BevelInnerPrompt)
                        SPIN(@n-4),AT(245,20,48,12),USE(BevelInner),IMM,RANGE(-255,255),STEP(1)
                        BUTTON('Panel Fill Color'),AT(324,11),USE(?ColorButton)
                        BUTTON('No Color'),AT(389,11),USE(?NoColorButton)
                        GROUP('Group 1'),AT(5,36,427,255),USE(?HideGroup)
                            OPTION,AT(3,143,58,17),USE(BevelSides[Bevel:Left:Outer],, ?ButtonLO)
                                RADIO,AT(5,145,15,15),USE(?ButtonLO:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(20,145,15,15),USE(?ButtonLO:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('4096')
                                RADIO,AT(35,145,15,15),USE(?ButtonLO:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('8192')
                                RADIO,AT(49,145,15,15),USE(?ButtonLO:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('12288')
                            END
                            OPTION('Left Inner'),AT(98,143,58,17),USE(BevelSides[Bevel:Left:Inner], |
                                , ?ButtonLI)
                                RADIO,AT(99,145,15,15),USE(?ButtonLI:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(114,145,15,15),USE(?ButtonLI:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('16384')
                                RADIO,AT(129,145,15,15),USE(?ButtonLI:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('32768')
                                RADIO,AT(143,145,15,15),USE(?ButtonLI:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('49152')
                            END
                            OPTION('Top Outer'),AT(190,42,58,17),USE(BevelSides[Bevel:Top:Outer], |
                                , ?ButtonTO)
                                RADIO,AT(189,44,15,15),USE(?ButtonTO:Radio1),LEFT,TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(204,44,15,15),USE(?ButtonTO:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('256')
                                RADIO,AT(219,44,15,15),USE(?ButtonTO:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('512')
                                RADIO,AT(233,44,15,15),USE(?ButtonTO:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('768')
                            END
                            OPTION('Top Inner'),AT(190,93,58,17),USE(BevelSides[Bevel:Top:Inner], |
                                , ?ButtonTI)
                                RADIO,AT(189,94,15,15),USE(?ButtonTI:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(204,94,15,15),USE(?ButtonTI:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('1024')
                                RADIO,AT(219,94,15,15),USE(?ButtonTI:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('2048')
                                RADIO,AT(233,94,15,15),USE(?ButtonTI:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('3072')
                            END
                            OPTION,AT(271,143,58,17),USE(BevelSides[Bevel:Right:Inner],, ?ButtonRI)
                                RADIO,AT(272,145,15,15),USE(?ButtonRI:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(287,145,15,15),USE(?ButtonRI:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('64')
                                RADIO,AT(301,145,15,15),USE(?ButtonRI:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('128')
                                RADIO,AT(316,145,15,15),USE(?ButtonRI:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('192')
                            END
                            OPTION,AT(367,143,58,17),USE(BevelSides[Bevel:Right:Outer],, ?ButtonRO)
                                RADIO,AT(367,145,15,15),USE(?ButtonRO:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(381,145,15,15),USE(?ButtonRO:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('16')
                                RADIO,AT(396,145,15,15),USE(?ButtonRO:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('32')
                                RADIO,AT(411,145,15,15),USE(?ButtonRO:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('48')
                            END
                            OPTION('Lower Inner'),AT(190,205,58,17),USE(BevelSides[Bevel:Bottom:Inner], |
                                , ?ButtonBI)
                                RADIO,AT(189,207,15,15),USE(?ButtonBI:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(204,207,15,15),USE(?ButtonBI:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('4')
                                RADIO,AT(219,207,15,15),USE(?ButtonBI:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('8')
                                RADIO,AT(233,207,15,15),USE(?ButtonBI:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('12')
                            END
                            OPTION,AT(190,260,58,17),USE(BevelSides[Bevel:Bottom:Outer],, ?ButtonBO)
                                RADIO,AT(189,262,15,15),USE(?ButtonBO:Radio1),TIP('No Bevel'), |
                                    ICON('N.ICO'),VALUE('0')
                                RADIO,AT(204,262,15,15),USE(?ButtonBO:Radio2),TIP('Raised Bevel'), |
                                    ICON('R.ICO'),VALUE('1')
                                RADIO,AT(219,262,15,15),USE(?ButtonBO:Radio3),TIP('Lowered Bevel'), |
                                    ICON('L.ICO'),VALUE('2')
                                RADIO,AT(233,262,15,15),USE(?ButtonBO:Radio4),TIP('Gray Bevel'), |
                                    ICON('G.ICO'),VALUE('3')
                            END
                        END
                        PANEL,AT(81,76,271,167),USE(?Panel1)
                        BUTTON('C&lear'),AT(5,294,55,14),USE(?Clear),TIP('Reset all settings to zero')
                        CHECK('&Hide Buttons'),AT(61,294,55,14),USE(HideButtons),ICON(ICON:None), |
                            TIP('Hide/Unhide the bevel buttons')
                        BUTTON('&Close'),AT(377,294,55,14),USE(?OkButton),STD(STD:Close),DEFAULT, |
                            TIP('Quit the Bevel Tool')
                    END

    CODE
        
      
        BevelStyle = GETREG(REG_CURRENT_USER,RegKey,'BevelStyle')
        BevelInner = GETREG(REG_CURRENT_USER,RegKey,'BevelInner')
        BevelOuter = GETREG(REG_CURRENT_USER,RegKey,'BevelOuter')  
        FillColor  = GETREG(REG_CURRENT_USER,RegKey,'FillColor')
        
        IF NOT BevelStyle + BevelInner + BevelOuter 
            BevelStyle = 9966h !We'll give some default values
            BevelInner = 8
            BevelOuter = 8 
            FillColor  = COLOR:NONE
        END

        OPEN( Window )

        ?Panel1{PROP:Fill} = FillColor
        
        SyncControls(TRUE)

        ACCEPT
            CASE EVENT()
            OF Event:Accepted
                CASE FIELD()
                OF ?Clear
                  BevelOuter  = 1
                  BevelInner  = 1
                  BevelStyle  = 0
                  HideButtons = 0
                  Post(Event:Accepted,?HideButtons)
                  SyncControls(TRUE)
                OF ?BevelStyle orof ?BevelInner orof ?BevelOuter
                  SyncControls(CHOOSE(FIELD()=?BevelStyle))
                OF ?ButtonLO OROF ?ButtonLI OROF ?ButtonTO OROF ?ButtonTI OROF ?ButtonRO OROF ?ButtonRI OROF ?ButtonBO OROF ?ButtonBI
                   CalculateStyle
                OF ?HideButtons
                    ?HideGroup{PROP:Hide}=HideButtons
                OF ?ColorButton
                    IF COLORDIALOG('Pick a Fill Color',FillColor)
                        ?Panel1{PROP:Fill} = FillColor
                    END
                    FormatBevelDec                    
                OF ?NoColorButton
                    FillColor = -1
                    ?Panel1{PROP:Fill} = FillColor                   
                    FormatBevelDec
                END
            OF Event:NewSelection
                CASE Field()
                OF ?BevelStyle OROF ?BevelInner OROF ?BevelOuter
                  UPDATE(?)
                  SyncControls(CHOOSE(FIELD()=?BevelStyle))
                END
            END
        END

        PUTREG(REG_CURRENT_USER,RegKey,'BevelStyle',BevelStyle,REG_DWORD)
        PUTREG(REG_CURRENT_USER,RegKey,'BevelInner',BevelInner,REG_DWORD)
        PUTREG(REG_CURRENT_USER,RegKey,'BevelOuter',BevelOuter,REG_DWORD)
        PUTREG(REG_CURRENT_USER,RegKey,'FillColor', FillColor,REG_DWORD)

!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

SyncControls PROCEDURE(LONG pReadStyle=0)

  CODE

        ?Panel1{PROP:BevelInner} = BevelInner
        ?Panel1{PROP:BevelOuter} = BevelOuter
        ?Panel1{PROP:BevelStyle} = BevelStyle
        HexStyle                 = Hex(BevelStyle)
        HexStyle                 = HexStyle[5:8] & 'h'

        IF pReadStyle
            CLEAR(BevelSides)
            BevelSides[Bevel:Left:Outer]   = BAND(BevelStyle,03000h)
            BevelSides[Bevel:Left:Inner]   = BAND(BevelStyle,0C000h)
            BevelSides[Bevel:Top:Outer]    = BAND(BevelStyle,00300h)
            BevelSides[Bevel:Top:Inner]    = BAND(BevelStyle,00C00h)
            BevelSides[Bevel:Right:Outer]  = BAND(BevelStyle,00030h)
            BevelSides[Bevel:Right:Inner]  = BAND(BevelStyle,000C0h)
            BevelSides[Bevel:Bottom:Outer] = BAND(BevelStyle,00003h)
            BevelSides[Bevel:Bottom:Inner] = BAND(BevelStyle,0000Ch)
        END
        
        FormatBevelDec
        DISPLAY
        RETURN

       
!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
CalculateStyle      PROCEDURE
Ndx                 LONG

    CODE
        
        BevelStyle = 0
        LOOP Ndx = 1 TO MAXIMUM(BevelSides,1)
            BevelStyle = BOR(BevelStyle, BevelSides[Ndx])
        END
        SyncControls(FALSE)
        DISPLAY
        
!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
FormatBevelDec      PROCEDURE !Format bevel attribute declaration 

    CODE

        BevelDec=''
        IF BevelInner OR BevelOuter OR BevelStyle
            BevelDec= ')'
            IF BevelStyle
                BevelDec = CHOOSE(~BevelInner,',','') & ',' & CLIP(HexStyle) & BevelDec
            END
            IF BevelInner
                BevelDec =   ',' & BevelInner & BevelDec
            END
            IF BevelOuter
                BevelDec = BevelOuter & BevelDec
            END
            BevelDec = 'BEVEL(' &  BevelDec
        END
        IF  FillColor <> COLOR:NONE
            BevelDec = CLIP(BevelDec) & ',FILL(' & Hex(FillColor) & 'h)'
        END
        DISPLAY(?BevelDec)
        
!:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Hex     FUNCTION(long l)
HexDig    STRING('0123456789ABCDEF'), STATIC
HexMap    GROUP, PRE(), OVER(l)
b4          BYTE
b3          BYTE
b2          BYTE
b1          BYTE
          END
HexVal    STRING(8), AUTO

  CODE

  HexVal[1] = HexDig[BSHIFT(b1, -4)+1]
  HexVal[2] = HexDig[BAND(b1, 0Fh)+1]
  HexVal[3] = HexDig[BSHIFT(b2, -4)+1]
  HexVal[4] = HexDig[BAND(b2, 0Fh)+1]
  HexVal[5] = HexDig[BSHIFT(b3, -4)+1]
  HexVal[6] = HexDig[BAND(b3, 0Fh)+1]
  HexVal[7] = HexDig[BSHIFT(b4, -4)+1]
  HexVal[8] = HexDig[BAND(b4, 0Fh)+1]
  RETURN HexVal

        