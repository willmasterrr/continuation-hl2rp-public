# Continuation Schema

I've decided to make the schema for continuation public, you have my full permission to use this code, but if you're a beginner, i would suggest you use my code more of an example than copy and pasting it, but im not stopping you.

There wont be any bug fixes

REQUIRES THIS MODULE!!: https://github.com/WilliamVenner/gmsv_reqwest

# My schema wont bootup!!!
you need to input a discord webhook link in the sv_webhook file.

# How do i setup an apartment?
The apartment system is really shitty and weird.

CONSOLE COMMAND LIST
impulse_door_remove_blockterminal > Removes the Block Terminal.
impulse_door_set_blockterminal 1 Terminal%sHotel > Sets & Saves the Block Terminal. you dont need to use impulse_save_mark for this.
impulse_door_setapartment true 101 1 > Sets a door to be the parent of an apartment room.

QUICK BREAKDOWN
In impulse_door_set_blockterminal, the first argument is a number which is the unique id of the apartment block, the second is the Apartment Block name, You have to use %s to make a space on the text.
Ex: Terminal%sHotel > Terminal Hotel

In impulse_door_setapartment, the first argument toggles if the door SHOULD be an apartment door or not, the second argument is the name of the apartment door, you can put anything here, it doesnt really matter. The third argument is the unique id where the apartment door should be part of, ex, 1 is Terminal Block and 2 is Block D. If i set it to 1, the door belongs to the Terminal Block, if i set it to 2, it belongs to Block D.

# Credits
i2games
Vin, aLoneWitness - (For clientside files)
