PD2QC: Payday 2 Quickchats Mod
------------------------------

No need to find a safe place in stealth while you take the time to type.
Stop standing still for snipers while trying to communicate with your pub team. 
With PD2QC, up to sixteen (16) phrases are at your finger tips with two (2) quick taps. 

Tap once to select from four categories: loud, stealth, general, and orders.
Tap again to select one of four phrases in each category. 

For example: 

Tap 🡇 🡆 for *"Let's move out."*

Tap 🡄 🡅 for *"Use your ECM now!!"*

Tap 🡄 🡇 for *"I need a medic bag!"*

Features
--------
•Ability to bind the quickchat menus to any key.

•Dynamically coded: easily modify the chat lines in the source to suit your needs.

•A quickchat hint panel so you don't have to memorize each menu.

•Compatibilty between most popular custom huds and the quickchat hint panel.  

•(In progress) Plays a relevant voice line when you use each chat.

Installation
-------------
**Requires BLT2.**

*Includes Delayed Calls Fix by SNH20.*

1. Extract "PD2QC-master" folder from the .zip into to your Payday 2 mods folder. 

2. Start the game and assign keybinds in Options->Mod Keybinds

Customizing
-----------
You can customize certain things about the mod without knowledge of lua coding. 

Want to change the specific text sent in chat? In the pd2qc.lua file, you can alter the quoted 
strings in the PD2QC.CHATS table. These changes will autoamtically be applied to the HUD. 

Use a custom HUD? You can change the posistion of PD2QC's HUD window by editing the pd2qc.lua file.
In the PD2QC.SETTINGS table, there is a setting called "hud_placement" followed by a number.
Change it to whichever fits your custom hud best: 0 is on the left, 1 is on the right, and 2 is in the middle.

*In a future update, these settings should be avalible via the in-game mod options menu.*
