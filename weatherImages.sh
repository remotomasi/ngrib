#!/bin/bash

awk '{gsub("<td>","\n<td>"); print}' final.html > finalMiddle.html
awk '{gsub("<td>","<td id=" ++n ">"); print}' finalMiddle.html > finalImages.html

