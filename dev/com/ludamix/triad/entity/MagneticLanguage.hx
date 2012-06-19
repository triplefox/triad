/*

moo moo, I am another language ghost

i think what i want is an interactive-mode language that controls actors

:foo;
go w 5;
with-other [go w 10; go s 20;]
say ["hey you, fuck off"]
goto foo;

basing it on .tc actually might work, we just add a space-separated mode on top and use that for parameters
string usages are all contextual here

Then compile it down to a bytecode......there could be some mapping of bytecode to method calls
	in fact, the mapping could be done via a specialized component:
		0->west();
		1->east();
		etc.
	...which means in turn that I have two languages to write
		one is a component with a set of functions to handle the runtime bytecode things
		one is a parser that maps keywords to function calls
		we can apply hscript on top of this to allow custom functions to be written
		
*/