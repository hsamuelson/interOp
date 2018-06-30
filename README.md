![](https://raw.githubusercontent.com/hsamuelson/interOp/master/logos.png)
# interOp
### Write in any programming language all in the same source file. <br>
Somethings are just better done in one language over another, but all languages have their shortcomings. Why make this trade? interOp allows you to leverage the power of all programming languages, without forcing yourself to stick to one language. Sometimes data analysis is better in R, but python has better ml libraries, why choose between them and easily program in both with interOp.   
<br>
interOp is also great for teams. Recently the development community has experienced a fragmentation of programming languages. interOp allows multiple developers to write in their preferential languages and work together to build one cohesive program; the way development should be.    


## Language Support
Other Versions of the langauges work, these are just the tested versions
<center>

| Language | Version | Basic Support | Arg support | Pipe Support |
|:-------|:-----:|:-------:|:-------:|:-------:|
| Python|3.7.0 | X | X | X |  
| R |3.5.0| X | X | X | 
| node js |8.11.3| X | X  |  |
| lua |v5.1.5-52| X | X |X |
| Go |1.10.3| X | X | X |  
| Elixir |1.6.6| X | |    |
| Batch |win10| X |X |    |
| Rust |1.27.0| X | |    |
| Ruby | 2.4.4-2| X | X|  X  |
| Perl | v5.24.3| X | X|    |
</center>

## Installation
See this link for installation instructions: <br>
https://github.com/hsamuelson/interOp/blob/master/installation.md

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
