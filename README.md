![](https://raw.githubusercontent.com/hsamuelson/interOp/master/logos.png)
# interOp
interOp is built to be a micro-service framework built for programming languages. The goal is anyone can write in any number of different languages in the same file and it will run micro-services to processes and recombine as one cohesive program.
## NOTE
This is still in development and only supports python, js and R.
## Requirements 
Only supported by windows.

The only requirement is the R programming language. The others are optional.<br>
node.js:
https://nodejs.org/en/download/ <br>
R:
https://cloud.r-project.org/ <br>
python:
https://www.python.org/downloads/windows/
## Syntax 
Every interop document has to start with a tag, something like ```#Yourname#```. What is inside of the ```#’s``` do not matter.
### Code Markdown & Modules
To create a new code markdown in a given language, type ```**``` then the language name. For example if I was writing in ```js``` I would write ```**js```. To signify the end of a code module use ```**/```. Each module needs a name (written above) in order to run and be called, to signify the name of a module, write its name above the language declaration. For example:
```
moduleFun 
**js
Var x = 2;
Console.log(x);
**/
```
One can create multiple modules in any language in any order.
## Running Modules
To run a module simply type ```** moduleName```. It is important to note, the module will not run on initiation, and will not run if there is a missing space between ```**``` and the module name.
  ### Module Arguments
  To pass a module an argument simply do: ``` ** moduleName arg```
  ### Pipe Operators 
  The pipe operator is ```**<<```. To input the output of one module into another is straight forward. To input ```mod1``` into ```mod2``` simply write: ```mod1 **<< mod2```. So far this is not supported with all languages. 
## Compiling InterOp
For now, simply run the batfile: ```interOp.bat``` from cmd. The interpreter only reads from one file ```mainscript.txt```.
#### From R:
You can also run the ```interpreter.R``` file to process the code. If you want to run it in a live R enviorment, simply load ```interpreter.R``` and then run ```master()``` to re-run code.
