FasdUAS 1.101.10   ��   ��    k             l        	  x     �� 
 ��   
 1      ��
�� 
ascr  �� ��
�� 
minv  m         �    2 . 5��    $  requires OS X 10.11 or higher    	 �   <   r e q u i r e s   O S   X   1 0 . 1 1   o r   h i g h e r      x    �� ����    2  	 ��
�� 
osax��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        x     -�� ����    4   " &�� 
�� 
frmk  m   $ %   �    E v e n t K i t��         l     ��������  ��  ��      ! " ! l     �� # $��   # � } You need to fetch the event store first; it's required for many other handlers. This also triggers authentication if needed.    $ � % % �   Y o u   n e e d   t o   f e t c h   t h e   e v e n t   s t o r e   f i r s t ;   i t ' s   r e q u i r e d   f o r   m a n y   o t h e r   h a n d l e r s .   T h i s   a l s o   t r i g g e r s   a u t h e n t i c a t i o n   i f   n e e d e d . "  & ' & i   - 0 ( ) ( I     ������
�� .!Cls!fstnull��� ��� null��  ��   ) k     o * *  + , + l     �� - .��   - < 6 create event store and get the OK to access Calendars    . � / / l   c r e a t e   e v e n t   s t o r e   a n d   g e t   t h e   O K   t o   a c c e s s   C a l e n d a r s ,  0 1 0 r      2 3 2 n     4 5 4 I    �������� 0 init  ��  ��   5 n     6 7 6 I    �������� 	0 alloc  ��  ��   7 n     8 9 8 o    ���� 0 ekeventstore EKEventStore 9 m     ��
�� misccura 3 o      ���� "0 theekeventstore theEKEventStore 1  : ; : n    < = < I    �� >���� N0 %requestaccesstoentitytype_completion_ %requestAccessToEntityType_completion_ >  ? @ ? m    ����   @  A�� A l    B���� B m    ��
�� 
msng��  ��  ��  ��   = o    ���� "0 theekeventstore theEKEventStore ;  C D C l   �� E F��   E Y S check if app has access; this will still occur the first time you OK authorization    F � G G �   c h e c k   i f   a p p   h a s   a c c e s s ;   t h i s   w i l l   s t i l l   o c c u r   t h e   f i r s t   t i m e   y o u   O K   a u t h o r i z a t i o n D  H I H r      J K J n    L M L I    �� N���� F0 !authorizationstatusforentitytype_ !authorizationStatusForEntityType_ N  O�� O m    ����  ��  ��   M n    P Q P o    ���� 0 ekeventstore EKEventStore Q m    ��
�� misccura K o      ���� *0 authorizationstatus authorizationStatus I  R S R Z   ! l T U���� T >  ! $ V W V o   ! "���� *0 authorizationstatus authorizationStatus W m   " #����  U k   ' h X X  Y Z Y I  ' 6�� [ \
�� .sysodlogaskr        TEXT [ b   ' , ] ^ ] b   ' * _ ` _ m   ' ( a a � b b T A c c e s s   m u s t   b e   g i v e n   i n   S y s t e m   P r e f e r e n c e s ` 1   ( )��
�� 
lnfd ^ m   * + c c � d d 8 - >   S e c u r i t y   &   P r i v a c y   f i r s t . \ �� e f
�� 
btns e J   - 0 g g  h�� h m   - . i i � j j  O K��   f �� k��
�� 
dflt k m   1 2���� ��   Z  l m l O   7 ] n o n k   ; \ p p  q r q I  ; @������
�� .miscactvnull��� ��� null��  ��   r  s�� s O  A \ t u t I  O [�� v��
�� .miscmvisnull���     **** v 4   O W�� w
�� 
xppa w m   S V x x � y y  P r i v a c y��   u 5   A L�� z��
�� 
xppb z m   E H { { � | | : c o m . a p p l e . p r e f e r e n c e . s e c u r i t y
�� kfrmID  ��   o m   7 8 } }�                                                                                  sprf  alis    T  Macintosh HD               ߁uBD ����System Settings.app                                            ����߁u        ����  
 cu             Applications  */:System:Applications:System Settings.app/  (  S y s t e m   S e t t i n g s . a p p    M a c i n t o s h   H D  'System/Applications/System Settings.app   / ��   m  ~�� ~ R   ^ h���� 
�� .ascrerr ****      � ****��    �� ���
�� 
errn � m   b e��������  ��  ��  ��   S  ��� � L   m o � � o   m n���� "0 theekeventstore theEKEventStore��   '  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � H B You often need a reference to the relevant calendar; get it here.    � � � � �   Y o u   o f t e n   n e e d   a   r e f e r e n c e   t o   t h e   r e l e v a n t   c a l e n d a r ;   g e t   i t   h e r e . �  � � � i   1 4 � � � I     �� � �
�� .!CLs!fcanull���     **** � o      ���� 0 calname calName � �� � �
�� 
!Cty � o      ���� 0 caltype calType � �� ���
�� 
!Cst � o      ���� 0 thestore theStore��   � k     d � �  � � � Z     @ � � � � � =      � � � o     ���� 0 caltype calType � m    ��
�� !Tct!TtL � r    	 � � � m    ����   � o      ���� 0 caltype calType �  � � � =     � � � o    ���� 0 caltype calType � m    ��
�� !Tct!TtC �  � � � r     � � � m    ����  � o      ���� 0 caltype calType �  � � � =     � � � o    ���� 0 caltype calType � m    ��
�� !Tct!TtE �  � � � r    ! � � � m    ����  � o      ���� 0 caltype calType �  � � � =   $ ' � � � o   $ %���� 0 caltype calType � m   % &��
�� !Tct!TtS �  � � � r   * - � � � m   * +����  � o      ���� 0 caltype calType �  � � � =   0 3 � � � o   0 1���� 0 caltype calType � m   1 2��
�� !Tct!TtB �  ��� � r   6 9 � � � m   6 7����  � o      ���� 0 caltype calType��   � R   < @�� ���
�� .ascrerr ****      � **** � m   > ? � � � � �   I n v a l i d   c a l   t y p e��   �  � � � l  A A�� � ���   � * $ get calendars that can store events    � � � � H   g e t   c a l e n d a r s   t h a t   c a n   s t o r e   e v e n t s �  � � � r   A I � � � n  A G � � � I   B G�� ����� 20 calendarsforentitytype_ calendarsForEntityType_ �  ��� � m   B C����  ��  ��   � o   A B���� 0 thestore theStore � o      ���� 0 thecalendars theCalendars �  � � � l  J J�� � ���   � !  get the requested calendar    � � � � 6   g e t   t h e   r e q u e s t e d   c a l e n d a r �  � � � r   J X � � � n  J V � � � I   M V�� ����� ,0 predicatewithformat_ predicateWithFormat_ �  � � � m   M N � � � � � 4 t i t l e   = =   % @   A N D   t y p e   I N   % @ �  � � � o   N O���� 0 calname calName �  ��� � J   O R � �  ��� � o   O P���� 0 caltype calType��  ��  ��   � n  J M � � � o   K M���� 0 nspredicate NSPredicate � m   J K��
�� misccura � o      ����  0 thenspredicate theNSPredicate �  ��� � L   Y d � � n  Y c � � � I   _ c����~�� 0 firstobject firstObject�  �~   � l  Y _ ��}�| � n  Y _ � � � I   Z _�{ ��z�{ <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_ �  ��y � o   Z [�x�x  0 thenspredicate theNSPredicate�y  �z   � o   Y Z�w�w 0 thecalendars theCalendars�}  �|  ��   �  � � � l     �v�u�t�v  �u  �t   �  � � � i   5 8 � � � I     �s � �
�s .!CLs!fcAnull���     **** � c       � � � o      �r�r  0 listofcalnames listOfCalNames � m      �q
�q 
list � �p � �
�p 
!CtY � |�o�n ��m ��o  �n   � c       � � � o      �l�l  0 listofcaltypes listOfCalTypes � m      �k
�k 
list�m   � J      �j�j   � �i ��h
�i 
!Cst � o      �g�g 0 thestore theStore�h   � k     � � �  �  � l     �f�f   * $ get calendars that can store events    � H   g e t   c a l e n d a r s   t h a t   c a n   s t o r e   e v e n t s   r      n    	 I    �e
�d�e 20 calendarsforentitytype_ calendarsForEntityType_
 �c m    �b�b  �c  �d  	 o     �a�a 0 thestore theStore o      �`�` 0 thecalendars theCalendars  Z   	 ��_ =   	  o   	 
�^�^  0 listofcaltypes listOfCalTypes J   
 �]�]   Z    )�\ =     o    �[�[  0 listofcalnames listOfCalNames J    �Z�Z   L     c     o    �Y�Y 0 thecalendars theCalendars m    �X
�X 
list�\   r    ) n   ' I   ! '�W�V�W ,0 predicatewithformat_ predicateWithFormat_  !  m   ! """ �##  t i t l e   I N   % @! $�U$ o   " #�T�T  0 listofcalnames listOfCalNames�U  �V   n   !%&% o    !�S�S 0 nspredicate NSPredicate& m    �R
�R misccura o      �Q�Q  0 thenspredicate theNSPredicate�_   k   , �'' ()( Y   , �*�P+,�O* k   : �-- ./. r   : @010 n   : >232 4   ; >�N4
�N 
cobj4 o   < =�M�M 0 i  3 o   : ;�L�L  0 listofcaltypes listOfCalTypes1 o      �K�K 0 caltype calType/ 565 Z   A �789:7 =   A D;<; o   A B�J�J 0 caltype calType< m   B C�I
�I !Tct!TtL8 r   G J=>= m   G H�H�H  > o      �G�G 0 caltype calType9 ?@? =   M PABA o   M N�F�F 0 caltype calTypeB m   N O�E
�E !Tct!TtC@ CDC r   S VEFE m   S T�D�D F o      �C�C 0 caltype calTypeD GHG =   Y \IJI o   Y Z�B�B 0 caltype calTypeJ m   Z [�A
�A !Tct!TtEH KLK r   _ bMNM m   _ `�@�@ N o      �?�? 0 caltype calTypeL OPO =   e hQRQ o   e f�>�> 0 caltype calTypeR m   f g�=
�= !Tct!TtSP STS r   k nUVU m   k l�<�< V o      �;�; 0 caltype calTypeT WXW =   q tYZY o   q r�:�: 0 caltype calTypeZ m   r s�9
�9 !Tct!TtBX [�8[ r   w z\]\ m   w x�7�7 ] o      �6�6 0 caltype calType�8  : R   } ��5^�4
�5 .ascrerr ****      � ****^ m    �__ �``   I n v a l i d   c a l   t y p e�4  6 a�3a r   � �bcb o   � ��2�2 0 caltype calTypec n      ded 4   � ��1f
�1 
cobjf o   � ��0�0 0 i  e o   � ��/�/  0 listofcaltypes listOfCalTypes�3  �P 0 i  + m   / 0�.�. , I  0 5�-g�,
�- .corecnte****       ****g o   0 1�+�+  0 listofcaltypes listOfCalTypes�,  �O  ) h�*h Z   � �ij�)ki =   � �lml o   � ��(�(  0 listofcalnames listOfCalNamesm J   � ��'�'  j r   � �non n  � �pqp I   � ��&r�%�& ,0 predicatewithformat_ predicateWithFormat_r sts m   � �uu �vv  t y p e   I N   % @t w�$w o   � ��#�#  0 listofcaltypes listOfCalTypes�$  �%  q n  � �xyx o   � ��"�" 0 nspredicate NSPredicatey m   � ��!
�! misccurao o      � �   0 thenspredicate theNSPredicate�)  k r   � �z{z n  � �|}| I   � ��~�� ,0 predicatewithformat_ predicateWithFormat_~ � m   � ��� ��� 4 t i t l e   I N   % @   A N D   t y p e   I N   % @� ��� o   � ���  0 listofcalnames listOfCalNames� ��� o   � ���  0 listofcaltypes listOfCalTypes�  �  } n  � ���� o   � ��� 0 nspredicate NSPredicate� m   � ��
� misccura{ o      ��  0 thenspredicate theNSPredicate�*   ��� L   � ��� c   � ���� l  � ����� n  � ���� I   � ����� <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_� ��� o   � ���  0 thenspredicate theNSPredicate�  �  � o   � ��� 0 thecalendars theCalendars�  �  � m   � ��
� 
list�   � ��� l     ����  �  �  � ��� l     ��
�	�  �
  �	  � ��� l     ����  � f ` In theory, more than one event can have the same external ID, so this returns a list of events.   � ��� �   I n   t h e o r y ,   m o r e   t h a n   o n e   e v e n t   c a n   h a v e   t h e   s a m e   e x t e r n a l   I D ,   s o   t h i s   r e t u r n s   a   l i s t   o f   e v e n t s .� ��� i   9 <��� I     ���
� .!CLs!feUnull���     ****� o      �� 0 calid calID� ���
� 
!Cst� o      �� 0 thestore theStore�  � k     �� ��� r     ��� l    ���� n    ��� I    � ����  L0 $calendaritemswithexternalidentifier_ $calendarItemsWithExternalIdentifier_� ���� o    ���� 0 calid calID��  ��  � o     ���� 0 thestore theStore�  �  � o      ���� 0 	theevents 	theEvents� ��� r   	 ��� n  	 ��� I   
 ������� 60 sortedarrayusingselector_ sortedArrayUsingSelector_� ���� m   
 �� ��� 4 c o m p a r e S t a r t D a t e W i t h E v e n t :��  ��  � o   	 
���� 0 	theevents 	theEvents� o      ���� 0 	theevents 	theEvents� ���� L    �� c    ��� o    ���� 0 	theevents 	theEvents� m    ��
�� 
list��  � ��� l     ��������  ��  ��  � ��� l     ������  � K E The main way to search for events. Dates can be AS dates or NSDates.   � ��� �   T h e   m a i n   w a y   t o   s e a r c h   f o r   e v e n t s .   D a t e s   c a n   b e   A S   d a t e s   o r   N S D a t e s .� ��� i   = @��� I     �����
�� .!CLs!feSnull��� ��� null��  � ����
�� 
!Csd� o      ���� 0 	startdate 	startDate� ����
�� 
!Ced� o      ���� 0 enddate endDate� ����
�� 
!Csc� o      ���� 0 callist calList� �����
�� 
!Cst� o      ���� 0 thestore theStore��  � k     J�� ��� l     ������  � � � check it it is a list/array of calendars, and if not make it one. We do this by making a new array and checking the class of its first object. This copes with arrays and lists.   � ���b   c h e c k   i t   i t   i s   a   l i s t / a r r a y   o f   c a l e n d a r s ,   a n d   i f   n o t   m a k e   i t   o n e .   W e   d o   t h i s   b y   m a k i n g   a   n e w   a r r a y   a n d   c h e c k i n g   t h e   c l a s s   o f   i t s   f i r s t   o b j e c t .   T h i s   c o p e s   w i t h   a r r a y s   a n d   l i s t s .� ��� r     
��� n    ��� I    ������� $0 arraywithobject_ arrayWithObject_� ���� o    ���� 0 callist calList��  ��  � n    ��� o    ���� 0 nsarray NSArray� m     ��
�� misccura� o      ���� 0 callistarray calListArray� ��� r    ��� n   ��� I    �������� 0 firstObject  ��  ��  � o    ���� 0 callistarray calListArray� o      ���� 0 callist calList� ��� Z   (������� H    �� c    ��� l   ������ n   ��� I    �������  0 iskindofclass_ isKindOfClass_� ���� l   ������ n   ��� o    ���� 0 nsarray NSArray� m    ��
�� misccura��  ��  ��  ��  � o    ���� 0 callist calList��  ��  � m    ��
�� 
bool� r   ! $��� o   ! "���� 0 callistarray calListArray� o      ���� 0 callist calList��  ��  � ��� r   ) 3��� n  ) 1��� I   * 1������� h0 2predicateforeventswithstartdate_enddate_calendars_ 2predicateForEventsWithStartDate_endDate_calendars_� ��� o   * +���� 0 	startdate 	startDate� ��� o   + ,���� 0 enddate endDate� ���� o   , -���� 0 callist calList��  ��  � o   ) *���� 0 thestore theStore� o      ���� 0 thepredicate thePredicate� � � r   4 < n  4 : I   5 :������ 40 eventsmatchingpredicate_ eventsMatchingPredicate_ �� o   5 6���� 0 thepredicate thePredicate��  ��   o   4 5���� 0 thestore theStore o      ���� 0 	theevents 	theEvents   r   = E	
	 n  = C I   > C������ 60 sortedarrayusingselector_ sortedArrayUsingSelector_ �� m   > ? � 4 c o m p a r e S t a r t D a t e W i t h E v e n t :��  ��   o   = >���� 0 	theevents 	theEvents
 o      ���� 0 	theevents 	theEvents �� L   F J c   F I o   F G���� 0 	theevents 	theEvents m   G H��
�� 
list��  �  l     ��������  ��  ��    l     ����   � � If you have retrieved events, you can use this to refine the resulting list. Summary, location, and description are case-insensitive strings; the other parameters are booleans. Pass missing value for parameters you're not interested in.    ��   I f   y o u   h a v e   r e t r i e v e d   e v e n t s ,   y o u   c a n   u s e   t h i s   t o   r e f i n e   t h e   r e s u l t i n g   l i s t .   S u m m a r y ,   l o c a t i o n ,   a n d   d e s c r i p t i o n   a r e   c a s e - i n s e n s i t i v e   s t r i n g s ;   t h e   o t h e r   p a r a m e t e r s   a r e   b o o l e a n s .   P a s s   m i s s i n g   v a l u e   f o r   p a r a m e t e r s   y o u ' r e   n o t   i n t e r e s t e d   i n .  i   A D I     ���� 
�� .!CLs!fe1null��� ��� null��    ��!"
�� 
!Cel! o      ���� 0 	theevents 	theEvents" ��#$
�� 
!Csu# |����%��&��  ��  % o      ���� 0 thetitle theTitle��  & m      ��
�� 
msng$ ��'(
�� 
!Clo' |����)��*��  ��  ) o      ���� 0 thelocation theLocation��  * m      ��
�� 
msng( ��+,
�� 
!CdD+ |����-��.��  ��  - o      ���� 0 desc  ��  . m      ��
�� 
msng, ��/0
�� 
!Cha/ |����1��2��  ��  1 o      ���� 0 hasa hasA��  2 m      ��
�� 
msng0 ��34
�� 
!Cre3 |����5��6��  ��  5 o      ���� 0 hasrecrules hasRecRules��  6 m      ��
�� 
msng4 ��7��
�� 
!Cad7 |����8��9��  ��  8 o      ���� 0 allday allDay��  9 m      ��
�� 
msng��   k    :: ;<; l     ��=>��  = � � check it it is a list/array of events, and if not make it one. We do this by making a new array and checking the class of its first object. This copes with arrays and lists.   > �??\   c h e c k   i t   i t   i s   a   l i s t / a r r a y   o f   e v e n t s ,   a n d   i f   n o t   m a k e   i t   o n e .   W e   d o   t h i s   b y   m a k i n g   a   n e w   a r r a y   a n d   c h e c k i n g   t h e   c l a s s   o f   i t s   f i r s t   o b j e c t .   T h i s   c o p e s   w i t h   a r r a y s   a n d   l i s t s .< @A@ r     
BCB n    DED I    ��F���� $0 arraywithobject_ arrayWithObject_F G��G o    ���� 0 	theevents 	theEvents��  ��  E n    HIH o    �� 0 nsarray NSArrayI m     �~
�~ misccuraC o      �}�}  0 theeventsarray theEventsArrayA JKJ r    LML n   NON I    �|�{�z�| 0 firstObject  �{  �z  O o    �y�y  0 theeventsarray theEventsArrayM o      �x�x 0 	theevents 	theEventsK PQP Z   (RS�w�vR H    TT c    UVU l   W�u�tW n   XYX I    �sZ�r�s  0 iskindofclass_ isKindOfClass_Z [�q[ l   \�p�o\ n   ]^] o    �n�n 0 nsarray NSArray^ m    �m
�m misccura�p  �o  �q  �r  Y o    �l�l 0 	theevents 	theEvents�u  �t  V m    �k
�k 
boolS r   ! $_`_ o   ! "�j�j  0 theeventsarray theEventsArray` o      �i�i 0 	theevents 	theEvents�w  �v  Q aba r   ) 3cdc n  ) 1efe I   , 1�hg�g�h (0 arraywithcapacity_ arrayWithCapacity_g h�fh m   , -�e�e �f  �g  f n  ) ,iji o   * ,�d�d  0 nsmutablearray NSMutableArrayj m   ) *�c
�c misccurad o      �b�b 0 	predarray 	predArrayb klk Z   4 Lmn�a�`m >  4 7opo o   4 5�_�_ 0 thetitle theTitlep m   5 6�^
�^ 
msngn n  : Hqrq I   ; H�]s�\�] 0 
addobject_ 
addObject_s t�[t l  ; Du�Z�Yu n  ; Dvwv I   > D�Xx�W�X ,0 predicatewithformat_ predicateWithFormat_x yzy m   > ?{{ �||  t i t l e   = = [ c ]   % @z }�V} o   ? @�U�U 0 thetitle theTitle�V  �W  w n  ; >~~ o   < >�T�T 0 nspredicate NSPredicate m   ; <�S
�S misccura�Z  �Y  �[  �\  r o   : ;�R�R 0 	predarray 	predArray�a  �`  l ��� Z   M e���Q�P� >  M P��� o   M N�O�O 0 thelocation theLocation� m   N O�N
�N 
msng� n  S a��� I   T a�M��L�M 0 
addobject_ 
addObject_� ��K� l  T ]��J�I� n  T ]��� I   W ]�H��G�H ,0 predicatewithformat_ predicateWithFormat_� ��� m   W X�� ��� " l o c a t i o n   = = [ c ]   % @� ��F� o   X Y�E�E 0 thelocation theLocation�F  �G  � n  T W��� o   U W�D�D 0 nspredicate NSPredicate� m   T U�C
�C misccura�J  �I  �K  �L  � o   S T�B�B 0 	predarray 	predArray�Q  �P  � ��� Z   f ���A�@� >  f i��� o   f g�?�? 0 desc  � m   g h�>
�> 
msng� n  l {��� I   m {�=��<�= 0 
addobject_ 
addObject_� ��;� l  m w��:�9� n  m w��� I   p w�8��7�8 ,0 predicatewithformat_ predicateWithFormat_� ��� m   p q�� ��� B h a s N o t e s   = =   % @   A N D   n o t e s   = = [ c ]   % @� ��� m   q r�6
�6 boovtrue� ��5� o   r s�4�4 0 desc  �5  �7  � n  m p��� o   n p�3�3 0 nspredicate NSPredicate� m   m n�2
�2 misccura�:  �9  �;  �<  � o   l m�1�1 0 	predarray 	predArray�A  �@  � ��� Z   � ����0�/� >  � ���� o   � ��.�. 0 hasa hasA� m   � ��-
�- 
msng� n  � ���� I   � ��,��+�, 0 
addobject_ 
addObject_� ��*� l  � ���)�(� n  � ���� I   � ��'��&�' ,0 predicatewithformat_ predicateWithFormat_� ��� m   � ��� ��� $ h a s A t t e n d e e s   = =   % @� ��%� o   � ��$�$ 0 hasa hasA�%  �&  � n  � ���� o   � ��#�# 0 nspredicate NSPredicate� m   � ��"
�" misccura�)  �(  �*  �+  � o   � ��!�! 0 	predarray 	predArray�0  �/  � ��� Z   � ���� �� >  � ���� o   � ��� 0 hasrecrules hasRecRules� m   � ��
� 
msng� n  � ���� I   � ����� 0 
addobject_ 
addObject_� ��� l  � ����� n  � ���� I   � ����� ,0 predicatewithformat_ predicateWithFormat_� ��� m   � ��� ��� 0 h a s R e c u r r e n c e R u l e s   = =   % @� ��� o   � ��� 0 hasrecrules hasRecRules�  �  � n  � ���� o   � ��� 0 nspredicate NSPredicate� m   � ��
� misccura�  �  �  �  � o   � ��� 0 	predarray 	predArray�   �  � ��� Z   � ������ >  � ���� o   � ��� 0 allday allDay� m   � ��
� 
msng� n  � ���� I   � ����� 0 
addobject_ 
addObject_� ��
� l  � ���	�� n  � ���� I   � ����� ,0 predicatewithformat_ predicateWithFormat_� ��� m   � ��� ���  a l l D a y   = =   % @� ��� o   � ��� 0 allday allDay�  �  � n  � ���� o   � ��� 0 nspredicate NSPredicate� m   � ��
� misccura�	  �  �
  �  � o   � ��� 0 	predarray 	predArray�  �  � ��� r   � ���� I  � �� ���
�  .corecnte****       ****� o   � ����� 0 	predarray 	predArray��  � o      ���� 0 thecount theCount� ��� l  � �������  � h b do nothing if count is 0; if 1, just use the first predicate in the array; otherwise and them all   � ��� �   d o   n o t h i n g   i f   c o u n t   i s   0 ;   i f   1 ,   j u s t   u s e   t h e   f i r s t   p r e d i c a t e   i n   t h e   a r r a y ;   o t h e r w i s e   a n d   t h e m   a l l� ��� Z   ������� =   � ���� o   � ����� 0 thecount theCount� m   � ����� � r   � ���� l  � ������� n  � �� � I   � ������� <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_ �� l  � ����� n  � � I   � ��������� 0 firstobject firstObject��  ��   o   � ����� 0 	predarray 	predArray��  ��  ��  ��    o   � ����� 0 	theevents 	theEvents��  ��  � o      ���� 0 	theevents 	theEvents�  ?   � �	 o   � ����� 0 thecount theCount	 m   � �����  
��
 k   �	  r   �  n  � � I   � ������� @0 andpredicatewithsubpredicates_ andPredicateWithSubpredicates_ �� o   � ����� 0 	predarray 	predArray��  ��   n  � � o   � ����� *0 nscompoundpredicate NSCompoundPredicate m   � ���
�� misccura o      ���� 0 thepred thePred �� r  	 l ���� n  I  ������ <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_ �� o  ���� 0 thepred thePred��  ��   o  ���� 0 	theevents 	theEvents��  ��   o      ���� 0 	theevents 	theEvents��  ��  ��  � �� L   c   !  o  ���� 0 	theevents 	theEvents! m  ��
�� 
list��   "#" l     ��������  ��  ��  # $%$ l     ��&'��  &�| When you have retrieved events, you can use this to refine the resulting list. If useRegex is true, the string(s) you pass will be treated as regular expression patterns, and matches will be sought. If useRegex is false, you can use ? as a wildcard for single characters and * as a wildcard for zero or more characters. Pass missing value for parameters you're not interested in.   ' �((�   W h e n   y o u   h a v e   r e t r i e v e d   e v e n t s ,   y o u   c a n   u s e   t h i s   t o   r e f i n e   t h e   r e s u l t i n g   l i s t .   I f   u s e R e g e x   i s   t r u e ,   t h e   s t r i n g ( s )   y o u   p a s s   w i l l   b e   t r e a t e d   a s   r e g u l a r   e x p r e s s i o n   p a t t e r n s ,   a n d   m a t c h e s   w i l l   b e   s o u g h t .   I f   u s e R e g e x   i s   f a l s e ,   y o u   c a n   u s e   ?   a s   a   w i l d c a r d   f o r   s i n g l e   c h a r a c t e r s   a n d   *   a s   a   w i l d c a r d   f o r   z e r o   o r   m o r e   c h a r a c t e r s .   P a s s   m i s s i n g   v a l u e   f o r   p a r a m e t e r s   y o u ' r e   n o t   i n t e r e s t e d   i n .% )*) i   E H+,+ I     ����-
�� .!CLs!fe2null��� ��� null��  - ��./
�� 
!Cel. o      ���� 0 	theevents 	theEvents/ ��01
�� 
!Csu0 |����2��3��  ��  2 o      ���� 0 thetitle theTitle��  3 m      ��
�� 
msng1 ��45
�� 
!CdD4 |����6��7��  ��  6 o      ���� 0 desc  ��  7 m      ��
�� 
msng5 ��89
�� 
!Clo8 |����:��;��  ��  : o      ���� 0 thelocation theLocation��  ; m      ��
�� 
msng9 ��<��
�� 
!Cre< |����=��>��  ��  = o      ���� 0 	regexflag 	regexFlag��  > m      ��
�� boovtrue��  , k     �?? @A@ l     ��BC��  B � � check it it is a list/array of events, and if not make it one. We do this by making a new array and checking the class of its first object. This copes with arrays and lists.   C �DD\   c h e c k   i t   i t   i s   a   l i s t / a r r a y   o f   e v e n t s ,   a n d   i f   n o t   m a k e   i t   o n e .   W e   d o   t h i s   b y   m a k i n g   a   n e w   a r r a y   a n d   c h e c k i n g   t h e   c l a s s   o f   i t s   f i r s t   o b j e c t .   T h i s   c o p e s   w i t h   a r r a y s   a n d   l i s t s .A EFE r     
GHG n    IJI I    ��K���� $0 arraywithobject_ arrayWithObject_K L��L o    ���� 0 	theevents 	theEvents��  ��  J n    MNM o    ���� 0 nsarray NSArrayN m     ��
�� misccuraH o      ����  0 theeventsarray theEventsArrayF OPO r    QRQ n   STS I    �������� 0 firstObject  ��  ��  T o    ����  0 theeventsarray theEventsArrayR o      ���� 0 	theevents 	theEventsP UVU Z   (WX����W H    YY c    Z[Z l   \����\ n   ]^] I    ��_����  0 iskindofclass_ isKindOfClass__ `��` l   a����a n   bcb o    ���� 0 nsarray NSArrayc m    ��
�� misccura��  ��  ��  ��  ^ o    ���� 0 	theevents 	theEvents��  ��  [ m    ��
�� 
boolX r   ! $ded o   ! "����  0 theeventsarray theEventsArraye o      ���� 0 	theevents 	theEvents��  ��  V fgf Z   ) [hi����h >  ) ,jkj o   ) *���� 0 thetitle theTitlek m   * +��
�� 
msngi k   / Wll mnm Z   / Nop��qo c   / 2rsr o   / 0���� 0 	regexflag 	regexFlags m   0 1��
�� 
boolp r   5 @tut n  5 >vwv I   8 >��x���� ,0 predicatewithformat_ predicateWithFormat_x yzy m   8 9{{ �||   t i t l e   M A T C H E S   % @z }��} o   9 :���� 0 thetitle theTitle��  ��  w n  5 8~~ o   6 8���� 0 nspredicate NSPredicate m   5 6��
�� misccurau o      ����  0 thenspredicate theNSPredicate��  q r   C N��� n  C L��� I   F L������� ,0 predicatewithformat_ predicateWithFormat_� ��� m   F G�� ���  t i t l e   L I K E   % @� ���� o   G H���� 0 thetitle theTitle��  ��  � n  C F��� o   D F���� 0 nspredicate NSPredicate� m   C D��
�� misccura� o      ����  0 thenspredicate theNSPredicaten ���� r   O W��� l  O U������ n  O U��� I   P U������ <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_� ��~� o   P Q�}�}  0 thenspredicate theNSPredicate�~  �  � o   O P�|�| 0 	theevents 	theEvents��  ��  � o      �{�{ 0 	theevents 	theEvents��  ��  ��  g ��� Z   \ ����z�y� >  \ _��� o   \ ]�x�x 0 desc  � m   ] ^�w
�w 
msng� k   b ��� ��� Z   b ����v�� c   b e��� o   b c�u�u 0 	regexflag 	regexFlag� m   c d�t
�t 
bool� r   h t��� n  h r��� I   k r�s��r�s ,0 predicatewithformat_ predicateWithFormat_� ��� m   k l�� ��� F h a s N o t e s   = =   % @   A N D   n o t e s   M A T C H E S   % @� ��� m   l m�q
�q boovtrue� ��p� o   m n�o�o 0 desc  �p  �r  � n  h k��� o   i k�n�n 0 nspredicate NSPredicate� m   h i�m
�m misccura� o      �l�l  0 thenspredicate theNSPredicate�v  � r   w ���� n  w ���� I   z ��k��j�k ,0 predicatewithformat_ predicateWithFormat_� ��� m   z {�� ��� @ h a s N o t e s   = =   % @   A N D   n o t e s   L I K E   % @� ��� m   { |�i
�i boovtrue� ��h� o   | }�g�g 0 desc  �h  �j  � n  w z��� o   x z�f�f 0 nspredicate NSPredicate� m   w x�e
�e misccura� o      �d�d  0 thenspredicate theNSPredicate� ��c� r   � ���� l  � ���b�a� n  � ���� I   � ��`��_�` <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_� ��^� o   � ��]�]  0 thenspredicate theNSPredicate�^  �_  � o   � ��\�\ 0 	theevents 	theEvents�b  �a  � o      �[�[ 0 	theevents 	theEvents�c  �z  �y  � ��� Z   � ����Z�Y� >  � ���� o   � ��X�X 0 thelocation theLocation� m   � ��W
�W 
msng� k   � ��� ��� Z   � ����V�� c   � ���� o   � ��U�U 0 useregex useRegex� m   � ��T
�T 
bool� r   � ���� n  � ���� I   � ��S��R�S ,0 predicatewithformat_ predicateWithFormat_� ��� m   � ��� ��� & l o c a t i o n   M A T C H E S   % @� ��Q� o   � ��P�P 0 thelocation theLocation�Q  �R  � n  � ���� o   � ��O�O 0 nspredicate NSPredicate� m   � ��N
�N misccura� o      �M�M  0 thenspredicate theNSPredicate�V  � r   � ���� n  � ���� I   � ��L��K�L ,0 predicatewithformat_ predicateWithFormat_� ��� m   � ��� ���   l o c a t i o n   L I K E   % @� ��J� o   � ��I�I 0 thelocation theLocation�J  �K  � n  � ���� o   � ��H�H 0 nspredicate NSPredicate� m   � ��G
�G misccura� o      �F�F  0 thenspredicate theNSPredicate� ��E� r   � ���� l  � ���D�C� n  � ���� I   � ��B��A�B <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_� ��@� o   � ��?�?  0 thenspredicate theNSPredicate�@  �A  � o   � ��>�> 0 	theevents 	theEvents�D  �C  � o      �=�= 0 	theevents 	theEvents�E  �Z  �Y  � ��<� L   � ��� c   � ���� o   � ��;�; 0 	theevents 	theEvents� m   � ��:
�: 
list�<  * ��� l     �9�8�7�9  �8  �7  � ��� l     �6���6  � f ` Deletes an event. For recurring events, futureFlag should be true to delete future recurrences.   � ��� �   D e l e t e s   a n   e v e n t .   F o r   r e c u r r i n g   e v e n t s ,   f u t u r e F l a g   s h o u l d   b e   t r u e   t o   d e l e t e   f u t u r e   r e c u r r e n c e s .� � � i   I L I     �5�4
�5 .!CLs!reEnull��� ��� null�4   �3
�3 
!Cev o      �2�2 0 theevent theEvent �1
�1 
!Cst o      �0�0 0 thestore theStore �/�.
�/ 
!Cft |�-�,	�+
�-  �,  	 o      �*�* 0 
futureflag 
futureFlag�+  
 m      �)
�) boovtrue�.   k     .  r      n    	 I    	�(�'�( @0 removeevent_span_commit_error_ removeEvent_span_commit_error_  o    �&�& 0 theevent theEvent  o    �%�% 0 
futureflag 
futureFlag  m    �$
�$ boovtrue �# l   �"�! m    � 
�  
obj �"  �!  �#  �'   o     �� 0 thestore theStore J        o      �� 0 	theresult 	theResult � o      �� 0 theerror theError�   � Z   . !��  H    "" c    #$# o    �� 0 	theresult 	theResult$ m    �
� 
bool! R     *�%�
� .ascrerr ****      � ****% l  " )&��& c   " )'(' n  " ')*) I   # '���� ,0 localizeddescription localizedDescription�  �  * o   " #�� 0 theerror theError( m   ' (�
� 
ctxt�  �  �  �  �  �    +,+ l     ����  �  �  , -.- l     �
/0�
  / � � Creates a new event. Location and notes can be missing value, start and end dates can be AS dates or NSDates, and allDay is a boolean. You still need to save it using the saveEvent::: handler below.   0 �11�   C r e a t e s   a   n e w   e v e n t .   L o c a t i o n   a n d   n o t e s   c a n   b e   m i s s i n g   v a l u e ,   s t a r t   a n d   e n d   d a t e s   c a n   b e   A S   d a t e s   o r   N S D a t e s ,   a n d   a l l D a y   i s   a   b o o l e a n .   Y o u   s t i l l   n e e d   t o   s a v e   i t   u s i n g   t h e   s a v e E v e n t : : :   h a n d l e r   b e l o w .. 232 i   M P454 I     �	�6
�	 .!CLs!crenull��� ��� null�  6 �78
� 
!Cst7 o      �� 0 thestore theStore8 �9:
� 
!Cdc9 o      �� 0 thecal theCal: �;<
� 
!Csu; o      �� 0 thetitle theTitle< �=>
� 
!Csd= o      � �  0 startd startD> ��?@
�� 
!Ced? o      ���� 0 endd endD@ ��AB
�� 
!CadA |����C��D��  ��  C o      ���� 0 allday allDay��  D m      ��
�� boovfalsB ��EF
�� 
!CloE |����G��H��  ��  G o      ���� 0 thelocation theLocation��  H m      ��
�� 
msngF ��I��
�� 
!CdDI |����J��K��  ��  J o      ���� 0 desc  ��  K m      ��
�� 
msng��  5 k     RLL MNM r     
OPO n    QRQ I    ��S���� ,0 eventwitheventstore_ eventWithEventStore_S T��T o    ���� 0 thestore theStore��  ��  R n    UVU o    ���� 0 ekevent EKEventV m     ��
�� misccuraP o      ���� 0 newevent newEventN WXW n   YZY I    ��[���� 0 setcalendar_ setCalendar_[ \��\ o    ���� 0 thecal theCal��  ��  Z o    ���� 0 newevent newEventX ]^] n   _`_ I    ��a���� 0 	settitle_ 	setTitle_a b��b o    ���� 0 thetitle theTitle��  ��  ` o    ���� 0 newevent newEvent^ cdc n   efe I    ��g���� 0 setstartdate_ setStartDate_g h��h o    ���� 0 startd startD��  ��  f o    ���� 0 newevent newEventd iji n    &klk I   ! &��m���� 0 setenddate_ setEndDate_m n��n o   ! "���� 0 endd endD��  ��  l o     !���� 0 newevent newEventj opo n  ' -qrq I   ( -��s���� 0 
setallday_ 
setAllDay_s t��t o   ( )���� 0 allday allDay��  ��  r o   ' (���� 0 newevent newEventp uvu Z  . >wx����w >  . 1yzy o   . /���� 0 thelocation theLocationz m   / 0��
�� 
msngx n  4 :{|{ I   5 :��}���� 0 setlocation_ setLocation_} ~��~ o   5 6���� 0 thelocation theLocation��  ��  | o   4 5���� 0 newevent newEvent��  ��  v � Z  ? O������� >  ? B��� o   ? @���� 0 desc  � m   @ A��
�� 
msng� n  E K��� I   F K������� 0 	setnotes_ 	setNotes_� ���� o   F G���� 0 desc  ��  ��  � o   E F���� 0 newevent newEvent��  ��  � ���� L   P R�� o   P Q���� 0 newevent newEvent��  3 ��� l     ��������  ��  ��  � ��� l     ������  � E ? Supply missing value for properties you do not want to change.   � ��� ~   S u p p l y   m i s s i n g   v a l u e   f o r   p r o p e r t i e s   y o u   d o   n o t   w a n t   t o   c h a n g e .� ��� i   Q T��� I     �����
�� .ICLs!mo1null��� ��� null��  � ����
�� 
!Cev� o      ���� 0 theevent theEvent� ����
�� 
!Cdc� o      ���� 0 thecal theCal� ����
�� 
!Csu� |����������  ��  � o      ���� 0 thetitle theTitle��  � m      ��
�� 
msng� ����
�� 
!Csd� |����������  ��  � o      ���� 0 startd startD��  � m      ��
�� 
msng� ����
�� 
!Ced� |����������  ��  � o      ���� 0 endd endD��  � m      ��
�� 
msng� ����
�� 
!Cad� |����������  ��  � o      ���� 0 allday allDay��  � m      ��
�� 
msng� ����
�� 
!Clo� |����������  ��  � o      ���� 0 thelocation theLocation��  � m      ��
�� 
msng� �����
�� 
!CdD� |����������  ��  � o      ���� 0 desc  ��  � m      ��
�� 
msng��  � k     y�� ��� Z    ������� >    ��� o     ���� 0 thecal theCal� m    ��
�� 
msng� n   ��� I    ������� 0 setcalendar_ setCalendar_� ���� o    ���� 0 thecal theCal��  ��  � o    �� 0 theevent theEvent��  ��  � ��� Z   !���~�}� >   ��� o    �|�| 0 thetitle theTitle� m    �{
�{ 
msng� n   ��� I    �z��y�z 0 	settitle_ 	setTitle_� ��x� o    �w�w 0 thetitle theTitle�x  �y  � o    �v�v 0 theevent theEvent�~  �}  � ��� Z  " 2���u�t� >  " %��� o   " #�s�s 0 startd startD� m   # $�r
�r 
msng� n  ( .��� I   ) .�q��p�q 0 setstartdate_ setStartDate_� ��o� o   ) *�n�n 0 startd startD�o  �p  � o   ( )�m�m 0 theevent theEvent�u  �t  � ��� Z  3 C���l�k� >  3 6��� o   3 4�j�j 0 endd endD� m   4 5�i
�i 
msng� n  9 ?��� I   : ?�h��g�h 0 setenddate_ setEndDate_� ��f� o   : ;�e�e 0 endd endD�f  �g  � o   9 :�d�d 0 theevent theEvent�l  �k  � ��� Z  D T���c�b� >  D G��� o   D E�a�a 0 allday allDay� m   E F�`
�` 
msng� n  J P��� I   K P�_��^�_ 0 
setallday_ 
setAllDay_� ��]� o   K L�\�\ 0 allday allDay�]  �^  � o   J K�[�[ 0 theevent theEvent�c  �b  � ��� Z  U e���Z�Y� >  U X��� o   U V�X�X 0 thelocation theLocation� m   V W�W
�W 
msng� n  [ a��� I   \ a�V��U�V 0 setlocation_ setLocation_� ��T� o   \ ]�S�S 0 thelocation theLocation�T  �U  � o   [ \�R�R 0 theevent theEvent�Z  �Y  � ��� Z  f v���Q�P� >  f i��� o   f g�O�O 0 desc  � m   g h�N
�N 
msng� n  l r��� I   m r�M��L�M 0 	setnotes_ 	setNotes_� ��K� o   m n�J�J 0 desc  �K  �L  � o   l m�I�I 0 theevent theEvent�Q  �P  � ��H� L   w y�� o   w x�G�G 0 theevent theEvent�H  � ��� l     �F�E�D�F  �E  �D  � ��� l     �C� �C  � n h The time zone can be missing value (for floating times), a valid time zone name, or a Cocoa NSTimeZone.     � �   T h e   t i m e   z o n e   c a n   b e   m i s s i n g   v a l u e   ( f o r   f l o a t i n g   t i m e s ) ,   a   v a l i d   t i m e   z o n e   n a m e ,   o r   a   C o c o a   N S T i m e Z o n e .�  i   U X I     �B�A
�B .!CLs!mo2null��� ��� null�A   �@
�@ 
!Cev o      �?�? 0 theevent theEvent �>	�=
�> 
!Ctz	 o      �<�< 0 tz  �=   k     ]

  Z     Z�; =     o     �:�: 0 tz   m    �9
�9 
msng n    I    �8�7�8 0 settimezone_ setTimeZone_ �6 o    �5�5 0 tz  �6  �7   o    �4�4 0 theevent theEvent�;   k    Z  l   �3�3   L F workaround to make sure tz is a Cocoa object so we can test its class    � �   w o r k a r o u n d   t o   m a k e   s u r e   t z   i s   a   C o c o a   o b j e c t   s o   w e   c a n   t e s t   i t s   c l a s s  r     n    !  I    �2�1�0�2 0 firstObject  �1  �0  ! l   "�/�." n   #$# I    �-%�,�- $0 arraywithobject_ arrayWithObject_% &�+& o    �*�* 0 tz  �+  �,  $ n   '(' o    �)�) 0 nsarray NSArray( m    �(
�( misccura�/  �.   o      �'�' 0 tz   )�&) Z    Z*+�%,* c    (-.- l   &/�$�#/ n   &010 I    &�"2�!�"  0 iskindofclass_ isKindOfClass_2 3� 3 l   "4��4 n   "565 o     "�� 0 nsstring NSString6 m     �
� misccura�  �  �   �!  1 o    �� 0 tz  �$  �#  . m   & '�
� 
bool+ k   + Q77 898 l  + +�:;�  : / ) make a time zone from string if possible   ; �<< R   m a k e   a   t i m e   z o n e   f r o m   s t r i n g   i f   p o s s i b l e9 =�= Z   + Q>?��> c   + 9@A@ l  + 7B��B n  + 7CDC I   2 7�E�� "0 containsobject_ containsObject_E F�F o   2 3�� 0 tz  �  �  D n  + 2GHG I   . 2���� (0 knowntimezonenames knownTimeZoneNames�  �  H n  + .IJI o   , .�� 0 
nstimezone 
NSTimeZoneJ m   + ,�
� misccura�  �  A m   7 8�

�
 
bool? k   < MKK LML r   < FNON n  < DPQP I   ? D�	R��	 &0 timezonewithname_ timeZoneWithName_R S�S o   ? @�� 0 tz  �  �  Q n  < ?TUT o   = ?�� 0 
nstimezone 
NSTimeZoneU m   < =�
� misccuraO o      �� 0 tz  M V�V n  G MWXW I   H M�Y� � 0 settimezone_ setTimeZone_Y Z��Z o   H I���� 0 tz  ��  �   X o   G H���� 0 theevent theEvent�  �  �  �  �%  , l  T Z[\][ n  T Z^_^ I   U Z��`���� 0 settimezone_ setTimeZone_` a��a o   U V���� 0 tz  ��  ��  _ o   T U���� 0 theevent theEvent\ &   assume it's already a time zone   ] �bb @   a s s u m e   i t ' s   a l r e a d y   a   t i m e   z o n e�&   c��c L   [ ]dd o   [ \���� 0 theevent theEvent��   efe l     ��������  ��  ��  f ghg l     ��ij��  i � � You pass the frequency as an integer or string, and the interval as an integer. If you supply a date (AS date or NSDate) for orEndDate:, it will be used, otherwise pass missing value for it, and the repeatCount: integer will be used.   j �kk�   Y o u   p a s s   t h e   f r e q u e n c y   a s   a n   i n t e g e r   o r   s t r i n g ,   a n d   t h e   i n t e r v a l   a s   a n   i n t e g e r .   I f   y o u   s u p p l y   a   d a t e   ( A S   d a t e   o r   N S D a t e )   f o r   o r E n d D a t e : ,   i t   w i l l   b e   u s e d ,   o t h e r w i s e   p a s s   m i s s i n g   v a l u e   f o r   i t ,   a n d   t h e   r e p e a t C o u n t :   i n t e g e r   w i l l   b e   u s e d .h lml i   Y \non I     ����p
�� .!CLs!mo3null��� ��� null��  p ��qr
�� 
!Cevq o      ���� 0 theevent theEventr ��st
�� 
!Cefs o      ���� 0 thefreq theFreqt ��uv
�� 
!Civu o      ���� 
0 interv  v ��wx
�� 
!Crew |����y��z��  ��  y o      ���� 0 repeatct repeatCt��  z m      ��
�� 
msngx ��{��
�� 
!Crd{ |����|��}��  ��  | o      ���� 0 
endingdate 
endingDate��  } m      ��
�� 
msng��  o k     u~~ � Z     4����� =     ��� o     ���� 0 thefreq theFreq� m    ��
�� !Efr!Eda� r    	��� m    ����  � o      ���� 0 thefreq theFreq� ��� =    ��� o    ���� 0 thefreq theFreq� m    ��
�� !Efr!Ewe� ��� r    ��� m    ���� � o      ���� 0 thefreq theFreq� ��� =    ��� o    ���� 0 thefreq theFreq� m    ��
�� !Efr!Emo� ��� r    !��� m    ���� � o      ���� 0 thefreq theFreq� ��� =   $ '��� o   $ %���� 0 thefreq theFreq� m   % &��
�� !Efr!Eye� ���� r   * -��� m   * +���� � o      ���� 0 thefreq theFreq��  � R   0 4�����
�� .ascrerr ****      � ****� m   2 3�� ��� 6 I n v a l i d   f r e q u e n c y   p a r a m e t e r��  � ��� Z   5 R������ =  5 8��� o   5 6���� 0 
endingdate 
endingDate� m   6 7��
�� 
msng� r   ; E��� n  ; C��� I   > C������� F0 !recurrenceendwithoccurrencecount_ !recurrenceEndWithOccurrenceCount_� ���� o   > ?���� 0 repeatct repeatCt��  ��  � n  ; >��� o   < >���� "0 ekrecurrenceend EKRecurrenceEnd� m   ; <��
�� misccura� o      ���� 0 	recurrend 	recurrEnd��  � r   H R��� n  H P��� I   K P������� 60 recurrenceendwithenddate_ recurrenceEndWithEndDate_� ���� o   K L���� 0 
endingdate 
endingDate��  ��  � n  H K��� o   I K���� "0 ekrecurrenceend EKRecurrenceEnd� m   H I��
�� misccura� o      ���� 0 	recurrend 	recurrEnd� ��� r   S c��� n  S a��� I   Z a������� V0 )initrecurrencewithfrequency_interval_end_ )initRecurrenceWithFrequency_interval_end_� ��� o   Z [���� 0 thefreq theFreq� ��� o   [ \���� 
0 interv  � ���� o   \ ]���� 0 	recurrend 	recurrEnd��  ��  � n  S Z��� I   V Z�������� 	0 alloc  ��  ��  � n  S V��� o   T V���� $0 ekrecurrencerule EKRecurrenceRule� m   S T��
�� misccura� o      ���� 0 
recurrrule 
recurrRule� ��� l  d d������  �    delete any existing first   � ��� 4   d e l e t e   a n y   e x i s t i n g   f i r s t� ��� I  d k�����
�� .!CLs!stpnull��� ��� null��  � �����
�� 
!Cev� o   f g���� 0 theevent theEvent��  � ��� n  l r��� I   m r������� (0 addrecurrencerule_ addRecurrenceRule_� ���� o   m n���� 0 
recurrrule 
recurrRule��  ��  � o   l m���� 0 theevent theEvent� ���� L   s u�� o   s t���� 0 theevent theEvent��  m ��� l     ��������  ��  ��  � ��� l     ������  � &   Turns off recurrence for event.   � ��� @   T u r n s   o f f   r e c u r r e n c e   f o r   e v e n t .� ��� i   ] `��� I     �����
�� .!CLs!stpnull��� ��� null��  � �����
�� 
!Cev� o      ���� 0 theevent theEvent��  � k     0�� ��� Z     -������� c     ��� n    ��� I    �������� (0 hasrecurrencerules hasRecurrenceRules��  ��  � o     ���� 0 theevent theEvent� m    ��
�� 
bool� k   
 )�� ��� r   
 ��� n  
 ��� I    �������� 0 recurrenceRules  ��  ��  � o   
 ���� 0 theevent theEvent� o      ���� 0 therules theRules� ���� Z   )������� ?    ��� l   ������ I   �����
�� .corecnte****       ****� o    ���� 0 therules theRules��  ��  ��  � m    ����  � n   %� � I    %������ .0 removerecurrencerule_ removeRecurrenceRule_ � l   !�~�} n    ! 4    !�|
�| 
cobj m     �{�{  o    �z�z 0 therules theRules�~  �}  �  ��    o    �y�y 0 theevent theEvent��  ��  ��  ��  ��  � �x L   . 0 o   . /�w�w 0 theevent theEvent�x  � 	
	 l     �v�u�t�v  �u  �t  
  l     �s�s   � � After you create or modify an event, you need to save it. For recurring events, futureFlag should be true to make changes apply to future events.    �$   A f t e r   y o u   c r e a t e   o r   m o d i f y   a n   e v e n t ,   y o u   n e e d   t o   s a v e   i t .   F o r   r e c u r r i n g   e v e n t s ,   f u t u r e F l a g   s h o u l d   b e   t r u e   t o   m a k e   c h a n g e s   a p p l y   t o   f u t u r e   e v e n t s .  i   a d I     �r�q
�r .!CLs!updnull��� ��� null�q   �p
�p 
!Cev o      �o�o 0 theevent theEvent �n
�n 
!Cst o      �m�m 0 thestore theStore �l�k
�l 
!Cft |�j�i�h�j  �i   o      �g�g 0 
futureflag 
futureFlag�h   m      �f
�f boovtrue�k   k     .  r       n    	!"! I    	�e#�d�e <0 saveevent_span_commit_error_ saveEvent_span_commit_error_# $%$ o    �c�c 0 theevent theEvent% &'& o    �b�b 0 
futureflag 
futureFlag' ()( m    �a
�a boovtrue) *�`* l   +�_�^+ m    �]
�] 
obj �_  �^  �`  �d  " o     �\�\ 0 thestore theStore  J      ,, -.- o      �[�[ 0 	theresult 	theResult. /�Z/ o      �Y�Y 0 theerror theError�Z   0�X0 Z   .12�W�V1 H    33 c    454 o    �U�U 0 	theresult 	theResult5 m    �T
�T 
bool2 R     *�S6�R
�S .ascrerr ****      � ****6 l  " )7�Q�P7 c   " )898 n  " ':;: I   # '�O�N�M�O 0 localizedDescription  �N  �M  ; o   " #�L�L 0 theerror theError9 m   ' (�K
�K 
ctxt�Q  �P  �R  �W  �V  �X   <=< l     �J�I�H�J  �I  �H  = >?> l     �G@A�G  @ 4 . This is the external id used by Calendar.app.   A �BB \   T h i s   i s   t h e   e x t e r n a l   i d   u s e d   b y   C a l e n d a r . a p p .? CDC i   e hEFE I     �F�EG
�F .!CLs!eidnull��� ��� null�E  G �DH�C
�D 
!CevH o      �B�B 0 theevent theEvent�C  F L     II c     JKJ n    LML I    �A�@�?�A "0 calendarItemExternalIdentifier  �@  �?  M o     �>�> 0 theevent theEventK m    �=
�= 
ctxtD NON l     �<�;�:�<  �;  �:  O PQP l     �9RS�9  R   returns record.   S �TT     r e t u r n s   r e c o r d .Q UVU i   i lWXW I     �8�7Y
�8 .!CLs!infnull��� ��� null�7  Y �6Z�5
�6 
!CevZ o      �4�4 0 theevent theEvent�5  X k    /[[ \]\ l     �3^_�3  ^ y s work around problem with null values in dictionaries; set initial nulls for all values that might be missing value   _ �`` �   w o r k   a r o u n d   p r o b l e m   w i t h   n u l l   v a l u e s   i n   d i c t i o n a r i e s ;   s e t   i n i t i a l   n u l l s   f o r   a l l   v a l u e s   t h a t   m i g h t   b e   m i s s i n g   v a l u e] aba r     	cdc n    efe I    �2�1�0�2 0 null  �1  �0  f n    ghg o    �/�/ 0 nsnull NSNullh m     �.
�. misccurad o      �-�- 0 thenull theNullb iji r   
 %klk n  
 #mnm I    #�,o�+�, @0 dictionarywithobjects_forkeys_ dictionaryWithObjects_forKeys_o pqp J    rr sts o    �*�* 0 thenull theNullt uvu o    �)�) 0 thenull theNullv wxw o    �(�( 0 thenull theNullx yzy o    �'�' 0 thenull theNullz {|{ o    �&�& 0 thenull theNull| }~} o    �%�% 0 thenull theNull~ �$ o    �#�# 0 thenull theNull�$  q ��"� J    �� ��� m    �� ���  e v e n t _ s u m m a r y� ��� m    �� ���  e v e n t _ t i m e _ z o n e� ��� m    �� ���  e v e n t _ l o c a t i o n� ��� m    �� ���  e v e n t _ u r l� ��� m    �� ��� " e v e n t _ d e s c r i p t i o n� ��� m    �� ���  e v e n t _ o r g a n i z e r� ��!� m    �� ��� & e v e n t _ o r i g i n a l _ d a t e�!  �"  �+  n n  
 ��� o    � �  *0 nsmutabledictionary NSMutableDictionary� m   
 �
� misccural o      �� 0 thedict theDictj ��� n  & 5��� I   ' 5���� &0 setobject_forkey_ setObject_forKey_� ��� l  ' 0���� n  ' 0��� I   , 0���� 	0 title  �  �  � n  ' ,��� I   ( ,���� 0 calendar  �  �  � o   ' (�� 0 theevent theEvent�  �  � ��� m   0 1�� ���  c a l e n d a r _ n a m e�  �  � o   & '�� 0 thedict theDict� ��� r   6 E��� c   6 C��� l  6 ?���� n  6 ?��� I   ; ?���� 0 type  �  �  � n  6 ;��� I   7 ;��
�	� 0 calendar  �
  �	  � o   6 7�� 0 theevent theEvent�  �  � m   ? B�
� 
long� o      �� 0 	theresult 	theResult� ��� n  F h��� I   G h���� &0 setobject_forkey_ setObject_forKey_� ��� l  G a���� n   G a��� 4   Z a��
� 
cobj� l  ] `�� ��� [   ] `��� o   ] ^���� 0 	theresult 	theResult� m   ^ _���� �   ��  � J   G Z�� ��� m   G J�� ��� 
 l o c a l� ��� m   J M�� ��� 
 c l o u d� ��� m   M P�� ���  E x c h a n g e� ��� m   P S�� ���  s u b s c r i p t i o n� ���� m   S V�� ���  b i r t h d a y��  �  �  � ���� m   a d�� ���  c a l e n d a r _ t y p e��  �  � o   F G���� 0 thedict theDict� ��� r   i p��� l  i n������ n  i n��� I   j n�������� 	0 title  ��  ��  � o   i j���� 0 theevent theEvent��  ��  � o      ���� 0 	theresult 	theResult� ��� Z  q �������� >  q v��� o   q r���� 0 	theresult 	theResult� m   r u��
�� 
msng� n  y ���� I   z �������� &0 setobject_forkey_ setObject_forKey_� ��� o   z {���� 0 	theresult 	theResult� ���� m   { ~�� ���  e v e n t _ s u m m a r y��  ��  � o   y z���� 0 thedict theDict��  ��  � ��� n  � ���� I   � �������� &0 setobject_forkey_ setObject_forKey_� ��� l  � ������� n  � ���� I   � ��������� "0 calendarItemExternalIdentifier  ��  ��  � o   � ����� 0 theevent theEvent��  ��  � ���� m   � ��� ��� " e v e n t _ e x t e r n a l _ I D��  ��  � o   � ����� 0 thedict theDict�    n  � � I   � ������� &0 setobject_forkey_ setObject_forKey_  l  � ����� n  � �	 I   � ��������� 0 	startDate  ��  ��  	 o   � ����� 0 theevent theEvent��  ��   
��
 m   � � �   e v e n t _ s t a r t _ d a t e��  ��   o   � ����� 0 thedict theDict  n  � � I   � ������� &0 setobject_forkey_ setObject_forKey_  l  � ����� n  � � I   � ��������� 0 endDate  ��  ��   o   � ����� 0 theevent theEvent��  ��   �� m   � � �  e v e n t _ e n d _ d a t e��  ��   o   � ����� 0 thedict theDict  n  � � I   � ������� &0 setobject_forkey_ setObject_forKey_   l  � �!����! n  � �"#" I   � ��������� 0 isAllDay  ��  ��  # o   � ����� 0 theevent theEvent��  ��    $��$ m   � �%% �&&  a l l _ d a y��  ��   o   � ����� 0 thedict theDict '(' r   � �)*) l  � �+����+ n  � �,-, I   � ��������� 0 timezone timeZone��  ��  - o   � ����� 0 theevent theEvent��  ��  * o      ���� 0 tz  ( ./. Z  � �01����0 >  � �232 o   � ����� 0 tz  3 m   � ���
�� 
msng1 n  � �454 I   � ���6���� &0 setobject_forkey_ setObject_forKey_6 787 l  � �9����9 n  � �:;: I   � ��������� 0 name  ��  ��  ; o   � ����� 0 tz  ��  ��  8 <��< m   � �== �>>  e v e n t _ t i m e _ z o n e��  ��  5 o   � ����� 0 thedict theDict��  ��  / ?@? r   � �ABA l  � �C����C n  � �DED I   � ��������� 0 location  ��  ��  E o   � ����� 0 theevent theEvent��  ��  B o      ���� 0 	theresult 	theResult@ FGF Z  � �HI����H >  � �JKJ o   � ����� 0 	theresult 	theResultK m   � ���
�� 
msngI n  � �LML I   � ���N���� &0 setobject_forkey_ setObject_forKey_N OPO o   � ����� 0 	theresult 	theResultP Q��Q m   � �RR �SS  e v e n t _ l o c a t i o n��  ��  M o   � ����� 0 thedict theDict��  ��  G TUT r   �VWV l  �X����X n  �YZY I   �������� 0 URL  ��  ��  Z o   � ���� 0 theevent theEvent��  ��  W o      ���� 0 theurl theURLU [\[ Z  ]^����] > _`_ o  ���� 0 theurl theURL` m  ��
�� 
msng^ n aba I  ��c���� &0 setobject_forkey_ setObject_forKey_c ded l f����f n ghg I  �������� 0 absoluteString  ��  ��  h o  ���� 0 theurl theURL��  ��  e i��i m  jj �kk  e v e n t _ u r l��  ��  b o  ���� 0 thedict theDict��  ��  \ lml r  !,non c  !*pqp l !&r����r n !&sts I  "&�������� 0 hasNotes  ��  ��  t o  !"���� 0 theevent theEvent��  ��  q m  &)��
�� 
boolo o      ���� 0 	theresult 	theResultm uvu Z  -Rwx��~w o  -.�}�} 0 	theresult 	theResultx k  1Nyy z{z r  18|}| l 16~�|�{~ n 16� I  26�z�y�x�z 	0 notes  �y  �x  � o  12�w�w 0 theevent theEvent�|  �{  } o      �v�v 0 	theresult 	theResult{ ��u� Z 9N���t�s� > 9>��� o  9:�r�r 0 	theresult 	theResult� m  :=�q
�q 
msng� n AJ��� I  BJ�p��o�p &0 setobject_forkey_ setObject_forKey_� ��� o  BC�n�n 0 	theresult 	theResult� ��m� m  CF�� ��� " e v e n t _ d e s c r i p t i o n�m  �o  � o  AB�l�l 0 thedict theDict�t  �s  �u  �  �~  v ��� r  SZ��� n SX��� I  TX�k�j�i�k 0 hasAttendees  �j  �i  � o  ST�h�h 0 theevent theEvent� o      �g�g 0 theattendees theAttendees� ��� Z  [����f�� c  [`��� o  [\�e�e 0 theattendees theAttendees� m  \_�d
�d 
bool� n cw��� I  dw�c��b�c &0 setobject_forkey_ setObject_forKey_� ��� l dp��a�`� n dp��� I  ip�_��^�_ 0 valueforkey_ valueForKey_� ��]� m  il�� ���  n a m e�]  �^  � n di��� I  ei�\�[�Z�\ 0 	attendees  �[  �Z  � o  de�Y�Y 0 theevent theEvent�a  �`  � ��X� m  ps�� ���  e v e n t _ a t t e n d e e s�X  �b  � o  cd�W�W 0 thedict theDict�f  � n z���� I  {��V��U�V &0 setobject_forkey_ setObject_forKey_� ��� J  {}�T�T  � ��S� m  }��� ���  e v e n t _ a t t e n d e e s�S  �U  � o  z{�R�R 0 thedict theDict� ��� n ����� I  ���Q��P�Q &0 setobject_forkey_ setObject_forKey_� ��� l ����O�N� n ����� I  ���M�L�K�M 0 hasRecurrenceRules  �L  �K  � o  ���J�J 0 theevent theEvent�O  �N  � ��I� m  ���� ��� $ e v e n t _ i s _ r e c u r r i n g�I  �P  � o  ���H�H 0 thedict theDict� ��� l ���G���G  � A ; \/ needs to be commented out, is a bug as of xmas day 2022   � ��� v   \ /   n e e d s   t o   b e   c o m m e n t e d   o u t ,   i s   a   b u g   a s   o f   x m a s   d a y   2 0 2 2� ��� l ���F���F  � V P  theDict's setObject:(theEvent's |creationDate|()) forKey:"event_creation_date"   � ��� �     t h e D i c t ' s   s e t O b j e c t : ( t h e E v e n t ' s   | c r e a t i o n D a t e | ( ) )   f o r K e y : " e v e n t _ c r e a t i o n _ d a t e "� ��� r  ����� l ����E�D� n ����� I  ���C�B�A�C 0 	organizer  �B  �A  � o  ���@�@ 0 theevent theEvent�E  �D  � o      �?�? 0 	theresult 	theResult� ��� Z  �����>�=� > ����� o  ���<�< 0 	theresult 	theResult� m  ���;
�; 
msng� k  ���� ��� r  ����� l ����:�9� n ����� I  ���8�7�6�8 0 name  �7  �6  � o  ���5�5 0 	theresult 	theResult�:  �9  � o      �4�4 0 	theresult 	theResult� ��3� Z �����2�1� > ����� o  ���0�0 0 	theresult 	theResult� m  ���/
�/ 
msng� n ����� I  ���.��-�. &0 setobject_forkey_ setObject_forKey_� ��� o  ���,�, 0 	theresult 	theResult� ��+� m  ���� ���  e v e n t _ o r g a n i z e r�+  �-  � o  ���*�* 0 thedict theDict�2  �1  �3  �>  �=  � ��� r  ����� l ����)�(� n ����� I  ���'�&�%�' 0 occurrenceDate  �&  �%  � o  ���$�$ 0 theevent theEvent�)  �(  � o      �#�# 0 	theresult 	theResult� ��� Z �����"�!� > ����� o  ��� �  0 	theresult 	theResult� m  ���
� 
msng� n ����� I  ������ &0 setobject_forkey_ setObject_forKey_� ��� o  ���� 0 	theresult 	theResult� ��� m  ��   � & e v e n t _ o r i g i n a l _ d a t e�  �  � o  ���� 0 thedict theDict�"  �!  �  r  �� l ���� n �� I  ������ 
0 status  �  �   o  ���� 0 theevent theEvent�  �   o      �� 0 	theresult 	theResult 	
	 Z  �(� = �� o  ���� 0 	theresult 	theResult m  ���
� 
msng n �� I  ����� &0 setobject_forkey_ setObject_forKey_  m  �� �  n o n e � m  �� �  e v e n t _ s t a t u s�  �   o  ���� 0 thedict theDict�   k  (  r   c    o  �� 0 	theresult 	theResult  m  �

�
 
long o      �	�	 0 	theresult 	theResult !�! n 	("#" I  
(�$�� &0 setobject_forkey_ setObject_forKey_$ %&% l 
!'��' n  
!()( 4  !�*
� 
cobj* l  +��+ [   ,-, o  � �  0 	theresult 	theResult- m  ���� �  �  ) J  
.. /0/ m  
11 �22  n o n e0 343 m  55 �66  c o n f i r m e d4 787 m  99 �::  t e n t a t i v e8 ;��; m  << �==  c a n c e l e d��  �  �  & >��> m  !$?? �@@  e v e n t _ s t a t u s��  �  # o  	
���� 0 thedict theDict�  
 A��A L  )/BB c  ).CDC o  )*���� 0 thedict theDictD m  *-��
�� 
reco��  V EFE l     ��������  ��  ��  F GHG l     ��IJ��  I    returns a list of records   J �KK 4   r e t u r n s   a   l i s t   o f   r e c o r d sH LML i   m pNON I     ����P
�� .!Cls!attnull��� ��� null��  P ��Q��
�� 
!CevQ o      ���� 0 theevent theEvent��  O Z     RS��TR c     UVU n    WXW I    �������� 0 hasattendees hasAttendees��  ��  X o     ���� 0 theevent theEventV m    ��
�� 
boolS k   
YY Z[Z r   
 \]\ n  
 ^_^ I    �������� 0 null  ��  ��  _ n  
 `a` o    ���� 0 nsnull NSNulla m   
 ��
�� misccura] o      ���� 0 thenull theNull[ bcb r    ded n   fgf I    �������� 0 	attendees  ��  ��  g o    ���� 0 theevent theEvente o      ���� 0 theattendees theAttendeesc hih r    %jkj n   #lml I    #�������� 	0 array  ��  ��  m n   non o    ����  0 nsmutablearray NSMutableArrayo m    ��
�� misccurak o      ���� 0 thearray theArrayi pqp X   &r��sr k   6tt uvu r   6 Ewxw l  6 Cy����y n  6 Cz{z I   9 C��|���� @0 dictionarywithobjects_forkeys_ dictionaryWithObjects_forKeys_| }~} J   9 < ���� o   9 :���� 0 thenull theNull��  ~ ���� J   < ?�� ���� m   < =�� ���  a t t e n d e e _ e m a i l��  ��  ��  { n  6 9��� o   7 9���� *0 nsmutabledictionary NSMutableDictionary� m   6 7��
�� misccura��  ��  x o      ���� 0 thedict theDictv ��� l  F Q������ n  F Q��� I   G Q������� &0 setobject_forkey_ setObject_forKey_� ��� l  G L������ n  G L��� I   H L�������� 0 name  ��  ��  � o   G H���� 0 
anattendee 
anAttendee��  ��  � ���� m   L M�� ���  a t t e n d e e _ n a m e��  ��  � o   F G���� 0 thedict theDict��  ��  � ��� r   R Y��� n  R W��� I   S W�������� 0 URL  ��  ��  � o   R S���� 0 
anattendee 
anAttendee� o      ���� 0 theemail theEmail� ��� Z  Z s������� >  Z _��� o   Z [���� 0 theemail theEmail� m   [ ^��
�� 
msng� l  b o������ n  b o��� I   c o������� &0 setobject_forkey_ setObject_forKey_� ��� l  c h������ n  c h��� I   d h�������� 0 resourceSpecifier  ��  ��  � o   c d���� 0 theemail theEmail��  ��  � ���� m   h k�� ���  a t t e n d e e _ e m a i l��  ��  � o   b c���� 0 thedict theDict��  ��  ��  ��  � ��� r   t ��� c   t }��� n  t y��� I   u y�������� 0 participantStatus  ��  ��  � o   t u���� 0 
anattendee 
anAttendee� m   y |��
�� 
long� o      ���� 0 	thestatus 	theStatus� ��� l  � ������� n  � ���� I   � �������� &0 setobject_forkey_ setObject_forKey_� ��� l  � ������� n   � ���� 4   � ����
�� 
cobj� l  � ������� [   � ���� o   � ����� 0 	thestatus 	theStatus� m   � ����� ��  ��  � J   � ��� ��� m   � ��� ���  u n k n o w n� ��� m   � ��� ���  p e n d i n g� ��� m   � ��� ���  a c c e p t e d� ��� m   � ��� ���  d e c l i n e d� ��� m   � ��� ���  t e n t a t i v e� ��� m   � ��� ���  d e l e g a t e d� ��� m   � ��� ���  c o m p l e t e d� ���� m   � ��� ���  i n   p r o c e s s��  ��  ��  � ���� m   � ��� ���  a t t e n d e e _ s t a t u s��  ��  � o   � ����� 0 thedict theDict��  ��  � ��� r   � ���� c   � ���� n  � ���� I   � ��������� 0 participantType  ��  ��  � o   � ����� 0 
anattendee 
anAttendee� m   � ���
�� 
long� o      ���� 0 thetype theType� ��� l  � ������� n  � ���� I   � �������� &0 setobject_forkey_ setObject_forKey_� ��� l  � ������� n   � ���� 4   � ����
�� 
cobj� l  � ������� [   � ���� o   � ����� 0 thetype theType� m   � ����� ��  ��  � J   � ��� 	 		  m   � �		 �		  u n k n o w n	 			 m   � �		 �		  p e r s o n	 				 m   � �	
	
 �		  r o o m		 			 m   � �		 �		  r e s o u r c e	 	��	 m   � �		 �		 
 g r o u p��  ��  ��  � 	��	 m   � �		 �		  a t t e n d e e _ t y p e��  ��  � o   � ����� 0 thedict theDict��  ��  � 			 r   � �			 c   � �			 n  � �			 I   � ��������� 0 participantRole  ��  ��  	 o   � ����� 0 
anattendee 
anAttendee	 m   � ��
� 
long	 o      �~�~ 0 therole theRole	 			 l  �	 �}�|	  n  �	!	"	! I   ��{	#�z�{ &0 setobject_forkey_ setObject_forKey_	# 	$	%	$ l  � �	&�y�x	& n   � �	'	(	' 4   � ��w	)
�w 
cobj	) l  � �	*�v�u	* [   � �	+	,	+ o   � ��t�t 0 therole theRole	, m   � ��s�s �v  �u  	( J   � �	-	- 	.	/	. m   � �	0	0 �	1	1  u n k n o w n	/ 	2	3	2 m   � �	4	4 �	5	5  r e q u i r e d	3 	6	7	6 m   � �	8	8 �	9	9  o p t i o n a l	7 	:	;	: m   � �	<	< �	=	= 
 c h a i r	; 	>�r	> m   � �	?	? �	@	@  n o n p a r t i c i p a n t�r  �y  �x  	% 	A�q	A m   � �	B	B �	C	C  a t t e n d e e _ r o l e�q  �z  	" o   � ��p�p 0 thedict theDict�}  �|  	 	D�o	D l 	E�n�m	E n 	F	G	F I  �l	H�k�l 0 
addobject_ 
addObject_	H 	I�j	I l 
	J�i�h	J n 
	K	L	K I  
�g�f�e�g 0 copy  �f  �e  	L o  �d�d 0 thedict theDict�i  �h  �j  �k  	G o  �c�c 0 thearray theArray�n  �m  �o  �� 0 
anattendee 
anAttendees o   ) *�b�b 0 theattendees theAttendeesq 	M�a	M L  	N	N c  	O	P	O o  �`�` 0 thearray theArray	P m  �_
�_ 
list�a  ��  T L   	Q	Q J  �^�^  M 	R	S	R l     �]�\�[�]  �\  �[  	S 	T	U	T l     �Z	V	W�Z  	V _ Y Returns a record. If occurrence_end_date is missing value, occurrence_frequency is used.   	W �	X	X �   R e t u r n s   a   r e c o r d .   I f   o c c u r r e n c e _ e n d _ d a t e   i s   m i s s i n g   v a l u e ,   o c c u r r e n c e _ f r e q u e n c y   i s   u s e d .	U 	Y	Z	Y i   q t	[	\	[ I     �Y�X	]
�Y .!CLs!rcrnull��� ��� null�X  	] �W	^�V
�W 
!Cev	^ o      �U�U 0 theevent theEvent�V  	\ k     �	_	_ 	`	a	` Z     �	b	c�T�S	b c     	d	e	d n    	f	g	f I    �R�Q�P�R (0 hasrecurrencerules hasRecurrenceRules�Q  �P  	g o     �O�O 0 theevent theEvent	e m    �N
�N 
bool	c k   
 �	h	h 	i	j	i r   
 	k	l	k n  
 	m	n	m I    �M�L�K�M 0 null  �L  �K  	n n  
 	o	p	o o    �J�J 0 nsnull NSNull	p m   
 �I
�I misccura	l o      �H�H 0 thenull theNull	j 	q	r	q r    #	s	t	s l   !	u�G�F	u n   !	v	w	v I    !�E	x�D�E @0 dictionarywithobjects_forkeys_ dictionaryWithObjects_forKeys_	x 	y	z	y J    	{	{ 	|�C	| o    �B�B 0 thenull theNull�C  	z 	}�A	} J    	~	~ 	�@	 m    	�	� �	�	� & o c c u r r e n c e _ e n d _ d a t e�@  �A  �D  	w n   	�	�	� o    �?�? *0 nsmutabledictionary NSMutableDictionary	� m    �>
�> misccura�G  �F  	t o      �=�= 0 thedict theDict	r 	�	�	� r   $ /	�	�	� n  $ -	�	�	� I   ) -�<�;�:�< 0 firstobject firstObject�;  �:  	� n  $ )	�	�	� I   % )�9�8�7�9 0 recurrenceRules  �8  �7  	� o   $ %�6�6 0 theevent theEvent	� o      �5�5 0 therule theRule	� 	�	�	� r   0 9	�	�	� c   0 7	�	�	� n  0 5	�	�	� I   1 5�4�3�2�4 0 	frequency  �3  �2  	� o   0 1�1�1 0 therule theRule	� m   5 6�0
�0 
long	� o      �/�/ 0 thefreq theFreq	� 	�	�	� l  : Q	��.�-	� n  : Q	�	�	� I   ; Q�,	��+�, &0 setobject_forkey_ setObject_forKey_	� 	�	�	� l  ; J	��*�)	� n   ; J	�	�	� 4   C J�(	�
�( 
cobj	� l  F I	��'�&	� [   F I	�	�	� o   F G�%�% 0 thefreq theFreq	� m   G H�$�$ �'  �&  	� J   ; C	�	� 	�	�	� m   ; <	�	� �	�	� 
 d a i l y	� 	�	�	� m   < =	�	� �	�	�  w e e k l y	� 	�	�	� m   = >	�	� �	�	�  m o n t h l y	� 	��#	� m   > ?	�	� �	�	�  y e a r l y�#  �*  �)  	� 	��"	� m   J M	�	� �	�	� ( o c c u r r e n c e _ f r e q u e n c y�"  �+  	� o   : ;�!�! 0 thedict theDict�.  �-  	� 	�	�	� l  R _	�� �	� n  R _	�	�	� I   S _�	��� &0 setobject_forkey_ setObject_forKey_	� 	�	�	� l  S X	���	� n  S X	�	�	� I   T X���� 0 interval  �  �  	� o   S T�� 0 therule theRule�  �  	� 	��	� m   X [	�	� �	�	� & o c c u r r e n c e _ i n t e r v a l�  �  	� o   R S�� 0 thedict theDict�   �  	� 	�	�	� r   ` g	�	�	� n  ` e	�	�	� I   a e���� 0 recurrenceEnd  �  �  	� o   ` a�� 0 therule theRule	� o      �� 0 	recurrend 	recurrEnd	� 	�	�	� Z   h �	�	���	� >  h m	�	�	� o   h i�� 0 	recurrend 	recurrEnd	� m   i l�
� 
msng	� k   p �	�	� 	�	�	� r   p w	�	�	� n  p u	�	�	� I   q u��
�	� 0 endDate  �
  �	  	� o   p q�� 0 	recurrend 	recurrEnd	� o      �� 0 recurrenddate recurrEndDate	� 	�	�	� Z  x �	�	���	� >  x }	�	�	� o   x y�� 0 recurrenddate recurrEndDate	� m   y |�
� 
msng	� n  � �	�	�	� I   � ��	��� &0 setobject_forkey_ setObject_forKey_	� 	�	�	� o   � �� �  0 recurrenddate recurrEndDate	� 	���	� m   � �	�	� �	�	� & o c c u r r e n c e _ e n d _ d a t e��  �  	� o   � ����� 0 thedict theDict�  �  	� 	�	�	� r   � �	�	�	� n  � �	�	�	� I   � ��������� 0 occurrenceCount  ��  ��  	� o   � ����� 0 	recurrend 	recurrEnd	� o      ���� 0 recurrcount recurrCount	� 	���	� n  � �	�	�	� I   � ���	����� &0 setobject_forkey_ setObject_forKey_	� 	�	�	� o   � ����� 0 recurrcount recurrCount	� 	���	� m   � �	�	� �	�	�   o c c u r r e n c e _ c o u n t��  ��  	� o   � ����� 0 thedict theDict��  �  �  	� 	���	� L   � �	�	� c   � �	�	�	� o   � ����� 0 thedict theDict	� m   � ���
�� 
reco��  �T  �S  	a 	���	� L   � �	�	� m   � ���
�� 
msng��  	Z 	���	� l     ��������  ��  ��  ��       ��	�	�	�	�	�
 








	





��  	� ��������������������������������������
�� 
pimr
�� .!Cls!fstnull��� ��� null
�� .!CLs!fcanull���     ****
�� .!CLs!fcAnull���     ****
�� .!CLs!feUnull���     ****
�� .!CLs!feSnull��� ��� null
�� .!CLs!fe1null��� ��� null
�� .!CLs!fe2null��� ��� null
�� .!CLs!reEnull��� ��� null
�� .!CLs!crenull��� ��� null
�� .ICLs!mo1null��� ��� null
�� .!CLs!mo2null��� ��� null
�� .!CLs!mo3null��� ��� null
�� .!CLs!stpnull��� ��� null
�� .!CLs!updnull��� ��� null
�� .!CLs!eidnull��� ��� null
�� .!CLs!infnull��� ��� null
�� .!Cls!attnull��� ��� null
�� .!CLs!rcrnull��� ��� null	� ��
�� 
  




 �� ��
�� 
vers��  
 ��
��
�� 
cobj
 

   ��
�� 
osax��  
 ��
��
�� 
cobj
 

   �� 
�� 
frmk��  
 ��
��
�� 
cobj
 

   �� 
�� 
frmk��  	� �� )����

��
�� .!Cls!fstnull��� ��� null��  ��  
 ������ "0 theekeventstore theEKEventStore�� *0 authorizationstatus authorizationStatus
 �������������� a�� c�� i������ }���� {���� x������
�� misccura�� 0 ekeventstore EKEventStore�� 	0 alloc  �� 0 init  
�� 
msng�� N0 %requestaccesstoentitytype_completion_ %requestAccessToEntityType_completion_�� F0 !authorizationstatusforentitytype_ !authorizationStatusForEntityType_
�� 
lnfd
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT
�� .miscactvnull��� ��� null
�� 
xppb
�� kfrmID  
�� 
xppa
�� .miscmvisnull���     ****
�� 
errn������ p��,j+ j+ E�O�j�l+ O��,jk+ E�O�m F��%�%��kv�k� O� #*j O*a a a 0 *a a /j UUO)a a lhY hO�	� �� �����

��
�� .!CLs!fcanull���     ****�� 0 calname calName�� ����

�� 
!Cty�� 0 caltype calType
 ������
�� 
!Cst�� 0 thestore theStore��  
 ������������ 0 calname calName�� 0 caltype calType�� 0 thestore theStore�� 0 thecalendars theCalendars��  0 thenspredicate theNSPredicate
 ������������ ������� �������
�� !Tct!TtL
�� !Tct!TtC
�� !Tct!TtE
�� !Tct!TtS
�� !Tct!TtB�� �� 20 calendarsforentitytype_ calendarsForEntityType_
�� misccura�� 0 nspredicate NSPredicate�� ,0 predicatewithformat_ predicateWithFormat_�� <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_�� 0 firstobject firstObject�� e��  jE�Y 6��  kE�Y *��  lE�Y ��  mE�Y ��  �E�Y )j�O�jk+ E�O��,ꠡkvm+ E�O��k+ j+ 	� �� �����

 ��
�� .!CLs!fcAnull���     ****�� {��������  0 listofcalnames listOfCalNames
�� 
list��  �� ��
!
"
�� 
!CtY
! {��������  0 listofcaltypes listOfCalTypes
�� 
list��  
" ������
�� 
!Cst�� 0 thestore theStore��  
 ����������������  0 listofcalnames listOfCalNames��  0 listofcaltypes listOfCalTypes�� 0 thestore theStore�� 0 thecalendars theCalendars��  0 thenspredicate theNSPredicate�� 0 i  �� 0 caltype calType
  ������~"�}�|�{�z�y�x�w�v�u_u��t�� 20 calendarsforentitytype_ calendarsForEntityType_
�� 
list
� misccura�~ 0 nspredicate NSPredicate�} ,0 predicatewithformat_ predicateWithFormat_
�| .corecnte****       ****
�{ 
cobj
�z !Tct!TtL
�y !Tct!TtC
�x !Tct!TtE
�w !Tct!TtS
�v !Tct!TtB�u �t <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_�� ��jk+  E�O�jv  �jv  	��&Y ��,�l+ E�Y � `k�j kh ��/E�O��  jE�Y 6��  kE�Y *��  lE�Y ��  mE�Y ��  �E�Y )j�O���/F[OY��O�jv  ��,�l+ E�Y ��,a ��m+ E�O��k+ �&
  �s��r�q
#
$�p
�s .!CLs!feUnull���     ****�r 0 calid calID�q �o�n�m
�o 
!Cst�n 0 thestore theStore�m  
# �l�k�j�l 0 calid calID�k 0 thestore theStore�j 0 	theevents 	theEvents
$ �i��h�g�i L0 $calendaritemswithexternalidentifier_ $calendarItemsWithExternalIdentifier_�h 60 sortedarrayusingselector_ sortedArrayUsingSelector_
�g 
list�p ��k+  E�O��k+ E�O��&
 �f��e�d
%
&�c
�f .!CLs!feSnull��� ��� null�e  �d �b�a
'
�b 
!Csd�a 0 	startdate 	startDate
' �`�_
(
�` 
!Ced�_ 0 enddate endDate
( �^�]
)
�^ 
!Csc�] 0 callist calList
) �\�[�Z
�\ 
!Cst�[ 0 thestore theStore�Z  
% �Y�X�W�V�U�T�S�Y 0 	startdate 	startDate�X 0 enddate endDate�W 0 callist calList�V 0 thestore theStore�U 0 callistarray calListArray�T 0 thepredicate thePredicate�S 0 	theevents 	theEvents
& �R�Q�P�O�N�M�L�K�J�I
�R misccura�Q 0 nsarray NSArray�P $0 arraywithobject_ arrayWithObject_�O 0 firstObject  �N  0 iskindofclass_ isKindOfClass_
�M 
bool�L h0 2predicateforeventswithstartdate_enddate_calendars_ 2predicateForEventsWithStartDate_endDate_calendars_�K 40 eventsmatchingpredicate_ eventsMatchingPredicate_�J 60 sortedarrayusingselector_ sortedArrayUsingSelector_
�I 
list�c K��,�k+ E�O�j+ E�O���,k+ �& �E�Y hO����m+ E�O��k+ E�O��k+ 	E�O��&
 �H�G�F
*
+�E
�H .!CLs!fe1null��� ��� null�G  �F �D�C
,
�D 
!Cel�C 0 	theevents 	theEvents
, �B
-
.
�B 
!Csu
- {�A�@�?�A 0 thetitle theTitle�@  
�? 
msng
. �>
/
0
�> 
!Clo
/ {�=�<�;�= 0 thelocation theLocation�<  
�; 
msng
0 �:
1
2
�: 
!CdD
1 {�9�8�7�9 0 desc  �8  
�7 
msng
2 �6
3
4
�6 
!Cha
3 {�5�4�3�5 0 hasa hasA�4  
�3 
msng
4 �2
5
6
�2 
!Cre
5 {�1�0�/�1 0 hasrecrules hasRecRules�0  
�/ 
msng
6 �.
7�-
�. 
!Cad
7 {�,�+�*�, 0 allday allDay�+  
�* 
msng�-  
* �)�(�'�&�%�$�#�"�!� ��) 0 	theevents 	theEvents�( 0 thetitle theTitle�' 0 thelocation theLocation�& 0 desc  �% 0 hasa hasA�$ 0 hasrecrules hasRecRules�# 0 allday allDay�"  0 theeventsarray theEventsArray�! 0 	predarray 	predArray�  0 thecount theCount� 0 thepred thePred
+ �����������{������������
� misccura� 0 nsarray NSArray� $0 arraywithobject_ arrayWithObject_� 0 firstObject  �  0 iskindofclass_ isKindOfClass_
� 
bool�  0 nsmutablearray NSMutableArray� � (0 arraywithcapacity_ arrayWithCapacity_
� 
msng� 0 nspredicate NSPredicate� ,0 predicatewithformat_ predicateWithFormat_� 0 
addobject_ 
addObject_
� .corecnte****       ****� <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_� *0 nscompoundpredicate NSCompoundPredicate� @0 andpredicatewithsubpredicates_ andPredicateWithSubpredicates_
� 
list�E��,�k+ E�O�j+ E�O���,k+ �& �E�Y hO��,�k+ E�O�� ���,�l+ k+ Y hO�� ���,�l+ k+ Y hO�� ���,�e�m+ k+ Y hO�� ���,a �l+ k+ Y hO�� ���,a �l+ k+ Y hO�� ���,a �l+ k+ Y hO�j E�O�k  ��j+ k+ E�Y !�k �a ,�k+ E�O��k+ E�Y hO�a &
 �,��

8
9�	
� .!CLs!fe2null��� ��� null�  �
 ��
:
� 
!Cel� 0 	theevents 	theEvents
: �
;
<
� 
!Csu
; {���� 0 thetitle theTitle�  
� 
msng
< �
=
>
� 
!CdD
= {�� ��� 0 desc  �   
�� 
msng
> ��
?
@
�� 
!Clo
? {�������� 0 thelocation theLocation��  
�� 
msng
@ ��
A��
�� 
!Cre
A {�������� 0 	regexflag 	regexFlag��  
�� boovtrue��  
8 ������������������ 0 	theevents 	theEvents�� 0 thetitle theTitle�� 0 desc  �� 0 thelocation theLocation�� 0 	regexflag 	regexFlag��  0 theeventsarray theEventsArray��  0 thenspredicate theNSPredicate�� 0 useregex useRegex
9 ����������������{�����������
�� misccura�� 0 nsarray NSArray�� $0 arraywithobject_ arrayWithObject_�� 0 firstObject  ��  0 iskindofclass_ isKindOfClass_
�� 
bool
�� 
msng�� 0 nspredicate NSPredicate�� ,0 predicatewithformat_ predicateWithFormat_�� <0 filteredarrayusingpredicate_ filteredArrayUsingPredicate_
�� 
list�	 ���,�k+ E�O�j+ E�O���,k+ �& �E�Y hO�� -��& ��,�l+ 	E�Y ��,�l+ 	E�O��k+ E�Y hO�� /��& ��,�e�m+ 	E�Y ��,�e�m+ 	E�O��k+ E�Y hO�� -��& ��,�l+ 	E�Y ��,�l+ 	E�O��k+ E�Y hO�a &
 ������
B
C��
�� .!CLs!reEnull��� ��� null��  �� ����
D
�� 
!Cev�� 0 theevent theEvent
D ����
E
�� 
!Cst�� 0 thestore theStore
E ��
F��
�� 
!Cft
F {�������� 0 
futureflag 
futureFlag��  
�� boovtrue��  
B ������������ 0 theevent theEvent�� 0 thestore theStore�� 0 
futureflag 
futureFlag�� 0 	theresult 	theResult�� 0 theerror theError
C ��������������
�� 
obj �� �� @0 removeevent_span_commit_error_ removeEvent_span_commit_error_
�� 
cobj
�� 
bool�� ,0 localizeddescription localizedDescription
�� 
ctxt�� /���e��+ E[�k/E�Z[�l/E�ZO��& )j�j+ �&Y h
 ��5����
G
H��
�� .!CLs!crenull��� ��� null��  �� ����
I
�� 
!Cst�� 0 thestore theStore
I ����
J
�� 
!Cdc�� 0 thecal theCal
J ����
K
�� 
!Csu�� 0 thetitle theTitle
K ����
L
�� 
!Csd�� 0 startd startD
L ����
M
�� 
!Ced�� 0 endd endD
M ��
N
O
�� 
!Cad
N {�������� 0 allday allDay��  
�� boovfals
O ��
P
Q
�� 
!Clo
P {�������� 0 thelocation theLocation��  
�� 
msng
Q ��
R��
�� 
!CdD
R {�������� 0 desc  ��  
�� 
msng��  
G 	�������������������� 0 thestore theStore�� 0 thecal theCal�� 0 thetitle theTitle�� 0 startd startD�� 0 endd endD�� 0 allday allDay�� 0 thelocation theLocation�� 0 desc  �� 0 newevent newEvent
H ����������������������
�� misccura�� 0 ekevent EKEvent�� ,0 eventwitheventstore_ eventWithEventStore_�� 0 setcalendar_ setCalendar_�� 0 	settitle_ 	setTitle_�� 0 setstartdate_ setStartDate_�� 0 setenddate_ setEndDate_�� 0 
setallday_ 
setAllDay_
�� 
msng�� 0 setlocation_ setLocation_�� 0 	setnotes_ 	setNotes_�� S��,�k+ E�O��k+ O��k+ O��k+ O��k+ O��k+ O�� ��k+ 	Y hO�� ��k+ 
Y hO�
 �������
S
T��
�� .ICLs!mo1null��� ��� null��  �� ����
U
�� 
!Cev�� 0 theevent theEvent
U ����
V
�� 
!Cdc�� 0 thecal theCal
V ��
W
X
�� 
!Csu
W {�������� 0 thetitle theTitle��  
�� 
msng
X ��
Y
Z
�� 
!Csd
Y {�������� 0 startd startD��  
�� 
msng
Z ��
[
\
�� 
!Ced
[ {�������� 0 endd endD��  
�� 
msng
\ ��
]
^
�� 
!Cad
] {�������� 0 allday allDay��  
�� 
msng
^ ��
_
`
�� 
!Clo
_ {������� 0 thelocation theLocation��  
� 
msng
` �~
a�}
�~ 
!CdD
a {�|�{�z�| 0 desc  �{  
�z 
msng�}  
S �y�x�w�v�u�t�s�r�y 0 theevent theEvent�x 0 thecal theCal�w 0 thetitle theTitle�v 0 startd startD�u 0 endd endD�t 0 allday allDay�s 0 thelocation theLocation�r 0 desc  
T �q�p�o�n�m�l�k�j
�q 
msng�p 0 setcalendar_ setCalendar_�o 0 	settitle_ 	setTitle_�n 0 setstartdate_ setStartDate_�m 0 setenddate_ setEndDate_�l 0 
setallday_ 
setAllDay_�k 0 setlocation_ setLocation_�j 0 	setnotes_ 	setNotes_�� z�� ��k+ Y hO�� ��k+ Y hO�� ��k+ Y hO�� ��k+ Y hO�� ��k+ Y hO�� ��k+ Y hO�� ��k+ Y hO�
 �i�h�g
b
c�f
�i .!CLs!mo2null��� ��� null�h  �g �e�d
d
�e 
!Cev�d 0 theevent theEvent
d �c�b�a
�c 
!Ctz�b 0 tz  �a  
b �`�_�` 0 theevent theEvent�_ 0 tz  
c �^�]�\�[�Z�Y�X�W�V�U�T�S�R
�^ 
msng�] 0 settimezone_ setTimeZone_
�\ misccura�[ 0 nsarray NSArray�Z $0 arraywithobject_ arrayWithObject_�Y 0 firstObject  �X 0 nsstring NSString�W  0 iskindofclass_ isKindOfClass_
�V 
bool�U 0 
nstimezone 
NSTimeZone�T (0 knowntimezonenames knownTimeZoneNames�S "0 containsobject_ containsObject_�R &0 timezonewithname_ timeZoneWithName_�f ^��  ��k+ Y M��,�k+ j+ E�O���,k+ �& +��,j+ 
�k+ �& ��,�k+ E�O��k+ Y hY ��k+ O�
 �Qo�P�O
e
f�N
�Q .!CLs!mo3null��� ��� null�P  �O �M�L
g
�M 
!Cev�L 0 theevent theEvent
g �K�J
h
�K 
!Cef�J 0 thefreq theFreq
h �I�H
i
�I 
!Civ�H 
0 interv  
i �G
j
k
�G 
!Cre
j {�F�E�D�F 0 repeatct repeatCt�E  
�D 
msng
k �C
l�B
�C 
!Crd
l {�A�@�?�A 0 
endingdate 
endingDate�@  
�? 
msng�B  
e �>�=�<�;�:�9�8�> 0 theevent theEvent�= 0 thefreq theFreq�< 
0 interv  �; 0 repeatct repeatCt�: 0 
endingdate 
endingDate�9 0 	recurrend 	recurrEnd�8 0 
recurrrule 
recurrRule
f �7�6�5�4��3�2�1�0�/�.�-�,�+�*�)
�7 !Efr!Eda
�6 !Efr!Ewe
�5 !Efr!Emo
�4 !Efr!Eye
�3 
msng
�2 misccura�1 "0 ekrecurrenceend EKRecurrenceEnd�0 F0 !recurrenceendwithoccurrencecount_ !recurrenceEndWithOccurrenceCount_�/ 60 recurrenceendwithenddate_ recurrenceEndWithEndDate_�. $0 ekrecurrencerule EKRecurrenceRule�- 	0 alloc  �, V0 )initrecurrencewithfrequency_interval_end_ )initRecurrenceWithFrequency_interval_end_
�+ 
!Cev
�* .!CLs!stpnull��� ��� null�) (0 addrecurrencerule_ addRecurrenceRule_�N v��  jE�Y *��  kE�Y ��  lE�Y ��  mE�Y )j�O��  ��,�k+ E�Y ��,�k+ 	E�O��,j+ ���m+ E�O*��l O��k+ O�
	 �(��'�&
m
n�%
�( .!CLs!stpnull��� ��� null�'  �& �$�#�"
�$ 
!Cev�# 0 theevent theEvent�"  
m �!� �! 0 theevent theEvent�  0 therules theRules
n ������� (0 hasrecurrencerules hasRecurrenceRules
� 
bool� 0 recurrenceRules  
� .corecnte****       ****
� 
cobj� .0 removerecurrencerule_ removeRecurrenceRule_�% 1�j+  �& $�j+ E�O�j j ���k/k+ Y hY hO�

 ���
o
p�
� .!CLs!updnull��� ��� null�  � ��
q
� 
!Cev� 0 theevent theEvent
q ��
r
� 
!Cst� 0 thestore theStore
r �
s�
� 
!Cft
s {���� 0 
futureflag 
futureFlag�  
� boovtrue�  
o ���
�	�� 0 theevent theEvent� 0 thestore theStore�
 0 
futureflag 
futureFlag�	 0 	theresult 	theResult� 0 theerror theError
p �������
� 
obj � � <0 saveevent_span_commit_error_ saveEvent_span_commit_error_
� 
cobj
� 
bool� 0 localizedDescription  
� 
ctxt� /���e��+ E[�k/E�Z[�l/E�ZO��& )j�j+ �&Y h
 � F����
t
u��
�  .!CLs!eidnull��� ��� null��  �� ������
�� 
!Cev�� 0 theevent theEvent��  
t ���� 0 theevent theEvent
u ������ "0 calendarItemExternalIdentifier  
�� 
ctxt�� 	�j+  �&
 ��X����
v
w��
�� .!CLs!infnull��� ��� null��  �� ������
�� 
!Cev�� 0 theevent theEvent��  
v ���������������� 0 theevent theEvent�� 0 thenull theNull�� 0 thedict theDict�� 0 	theresult 	theResult�� 0 tz  �� 0 theurl theURL�� 0 theattendees theAttendees
w G����������������������������������������������������%����=��R����j������������������������ ��159<��?��
�� misccura�� 0 nsnull NSNull�� 0 null  �� *0 nsmutabledictionary NSMutableDictionary�� �� @0 dictionarywithobjects_forkeys_ dictionaryWithObjects_forKeys_�� 0 calendar  �� 	0 title  �� &0 setobject_forkey_ setObject_forKey_�� 0 type  
�� 
long�� 
�� 
cobj
�� 
msng�� "0 calendarItemExternalIdentifier  �� 0 	startDate  �� 0 endDate  �� 0 isAllDay  �� 0 timezone timeZone�� 0 name  �� 0 location  �� 0 URL  �� 0 absoluteString  �� 0 hasNotes  
�� 
bool�� 	0 notes  �� 0 hasAttendees  �� 0 	attendees  �� 0 valueforkey_ valueForKey_�� 0 hasRecurrenceRules  �� 0 	organizer  �� 0 occurrenceDate  �� 
0 status  �� 
�� 
reco��0��,j+ E�O��,��������v��������vl+ E�O��j+ j+ �l+ O�j+ j+ a &E�O�a a a a a a va �k/a l+ O�j+ E�O�a  ��a l+ Y hO��j+ a l+ O��j+ a  l+ O��j+ !a "l+ O��j+ #a $l+ O�j+ %E�O�a  ��j+ &a 'l+ Y hO�j+ (E�O�a  ��a )l+ Y hO�j+ *E�O�a  ��j+ +a ,l+ Y hO�j+ -a .&E�O� "�j+ /E�O�a  ��a 0l+ Y hY hO�j+ 1E�O�a .& ��j+ 2a 3k+ 4a 5l+ Y �jva 6l+ O��j+ 7a 8l+ O�j+ 9E�O�a  "�j+ &E�O�a  ��a :l+ Y hY hO�j+ ;E�O�a  ��a <l+ Y hO�j+ =E�O�a   �a >a ?l+ Y )�a &E�O�a @a Aa Ba Ca Dva �k/a El+ O�a F&
 ��O����
x
y��
�� .!Cls!attnull��� ��� null��  �� ������
�� 
!Cev�� 0 theevent theEvent��  
x 
���������������������� 0 theevent theEvent�� 0 thenull theNull�� 0 theattendees theAttendees�� 0 thearray theArray�� 0 
anattendee 
anAttendee�� 0 thedict theDict�� 0 theemail theEmail�� 0 	thestatus 	theStatus�� 0 thetype theType�� 0 therole theRole
y 3��������������������������������������������������������			
		��	��	0	4	8	<	?	B�������� 0 hasattendees hasAttendees
�� 
bool
�� misccura�� 0 nsnull NSNull�� 0 null  �� 0 	attendees  ��  0 nsmutablearray NSMutableArray�� 	0 array  
�� 
kocl
�� 
cobj
�� .corecnte****       ****�� *0 nsmutabledictionary NSMutableDictionary�� @0 dictionarywithobjects_forkeys_ dictionaryWithObjects_forKeys_�� 0 name  �� &0 setobject_forkey_ setObject_forKey_�� 0 URL  
�� 
msng�� 0 resourceSpecifier  �� 0 participantStatus  
�� 
long�� �� 0 participantType  �� �� 0 participantRole  �� 0 copy  �� 0 
addobject_ 
addObject_
�� 
list��!�j+  �&��,j+ E�O�j+ E�O��,j+ E�O �[��l 
kh ��,�kv�kvl+ E�O��j+ �l+ O�j+ E�O�a  ��j+ a l+ Y hO�j+ a &E�O�a a a a a a a a a v�k/a  l+ O�j+ !a &E�O�a "a #a $a %a &a 'v�k/a (l+ O�j+ )a &E�O�a *a +a ,a -a .a 'v�k/a /l+ O��j+ 0k+ 1[OY�"O�a 2&Y jv
 ��	\����
z
{��
�� .!CLs!rcrnull��� ��� null��  �� ������
�� 
!Cev�� 0 theevent theEvent��  
z ������������������ 0 theevent theEvent�� 0 thenull theNull�� 0 thedict theDict�� 0 therule theRule�� 0 thefreq theFreq�� 0 	recurrend 	recurrEnd�� 0 recurrenddate recurrEndDate�� 0 recurrcount recurrCount
{ ������������	�����������	�	�	�	���~	��}�|	��{�z�y	��x	��w�� (0 hasrecurrencerules hasRecurrenceRules
�� 
bool
�� misccura�� 0 nsnull NSNull�� 0 null  �� *0 nsmutabledictionary NSMutableDictionary�� @0 dictionarywithobjects_forkeys_ dictionaryWithObjects_forKeys_�� 0 recurrenceRules  �� 0 firstobject firstObject�� 0 	frequency  
�� 
long� 
�~ 
cobj�} &0 setobject_forkey_ setObject_forKey_�| 0 interval  �{ 0 recurrenceEnd  
�z 
msng�y 0 endDate  �x 0 occurrenceCount  
�w 
reco�� ��j+  �& ���,j+ E�O��,�kv�kvl+ E�O�j+ j+ 	E�O�j+ 
�&E�O�����a va �k/a l+ O��j+ a l+ O�j+ E�O�a  4�j+ E�O�a  ��a l+ Y hO�j+ E�O��a l+ Y hO�a &Y hOa  ascr  ��ޭ