![](https://raw.githubusercontent.com/hsamuelson/interOp/master/logos.png)
# interOp
### Write in any programming language, all in the same source file. <br>
Some things are just better in one language than another, but all languages have their shortcomings. Why make the trade-off? interOp allows you to leverage the power of all programming languages, without forcing yourself to stick to one language. Want to implement strong data analysis with R, but don't want to sacrifice the powerful machine learning of Python libraries? Now you don't have to, with interOp.
<br>
interOp is also great for teams. Recently the development community has experienced a fragmentation of programming languages. interOp allows multiple developers to write in their preferred languages and work together to build one cohesive program; the way development should be.    
<br>

## Language Support
Note: other language versions may still work, however the following are verified
<center>

| Language | Version | Basic Support | Arg support | Pipe Support |
|:-------|:-----:|:-------:|:-------:|:-------:|
| Python|3.7.0 | X | X | X |  
| R |3.5.0| X | X | X | 
| Node.js |8.11.3| X | X  |  |
| Lua |v5.1.5-52| X | X |X |
| Go |1.10.3| X | X | X |  
| Elixir |1.6.6| X | |    |
| Batch |win10| X |X |    |
| Rust |1.27.0| X | |    |
| Ruby | 2.4.4-2| X | X|  X  |
| Perl | v5.24.3| X | X|    |
| Dart | 1.24.3| X | |    |
| Java | jdk1.8.0_171*| X |  |    |

*Note: If you choose to use java it is important to use this exact jdk
</center>

## Installation
See this link for installation instructions: <br>
https://github.com/hsamuelson/interOp/blob/master/documentation/installation.md

## Syntax 

### Code Markdown & Modules
To create a new code markdown in a given language, type ```**``` then the language name. For example if I was writing in ```js``` I would write ```**js```. To signify the end of a code module use ```**/```. Each module needs a name (shown below) in order to run and be called. For example:
```
 
**js jsModule simple
Var x = 2;
Console.log(x);
**/
```
One can create multiple modules in any language and in any order. "simple" is the output data type. Currently ```simple``` is required at the end of all code module declarations. 
## Running Modules
To run a module simply type ```** moduleName```. It is important to note the module will not run on initiation, and will not run if there is a missing space between ```**``` and the module name.
### Module Arguments
To pass a module an argument simply write: ``` ** moduleName arg```
### Pipe Operators 
The pipe operator is ```**<<```. To input the output of one module into another is easy. To input ```mod1``` into ```mod2``` simply write: ```mod1 **<< mod2```. So far this is not supported with all languages (see above).
## Compiling InterOp
For now from commandline/powershell run the ```interOp.bat``` file with a ```.interOp``` file as its arg. It will look like this:
```
interOp.bat ".\scripts\python.interOp"
```
This powershell command will run the python file (assuming python is installed). You can find examples for all supported languages in the ```/scripts``` folder. If you want an example of what it looks like to run multiple languages in a single file see ```mainScript.interOp```. (Note: it will need all supported languages installed to properly execute.) <br>
There are a few valid command line args for ```interOp.bat```. Passing it no arguments means it will allow you to select a file via a GUI. This would look like ```interOp.bat``` in the console. 
Inputting the number ```1``` as an argument will default the script to reading ```mainScript.interOp```.

#### From R:
You can also run the ```interpreter.R``` file to process the code. If you want to run it in a live R envirment, simply load ```interpreter.R``` and then run ```master()``` to re-run code.

## Credits
Henry Samuelson <br>
Samuel Freisem-Kirov <br>
Henry Meng
