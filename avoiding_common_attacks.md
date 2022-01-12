Proper use of Require, Assert and Revert
- require in the reserve and buy functions to limit the amount of tickets that the user can acquire
- used assert in the withdraw function to ensure that all eth is withdrawn

SWC-101: Integer Overflow and Underflow
-  Using the safemath library to provide protection for uint overflow/underflow

SWC-115: Authorization through tx.origin 
-  Preventing tx.origin authorization attack by using msg.sender