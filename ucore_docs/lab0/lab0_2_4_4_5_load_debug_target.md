##### 加载调试目标

在上面小节，我们提到为了能够让gdb识别变量的符号，我们必须给gdb载入符号表等信息。在进行gdb本地应用程序调试的时候，因为在指定了执行文件时就已经加载了文件中包含的调试信息，因此不用再使用gdb命令专门加载了。但是在使用qemu进行远程调试的时候，我们必须手动加载符号表，也就是在gdb中用file命令。

这样加载调试信息都是按照elf文件中制定的虚拟地址进行加载的，这在静态连接的代码中没有任何问题。但是在调试含有动态链接库的代码时，动态链接库的ELF执行文件头中指定的加载虚拟地址都是0，这个地址实际上是不正确的。从操作系统角度来看，用户态的动态链接库的加载地址都是由操作系统动态分配的，没有一个固定值。然后操作系统再把动态链接库加载到这个地址，并由用户态的库链接器（linker）把动态链接库中的地址信息重新设置，自此动态链接库才可正常运行。

由于分配地址的动态性，gdb并不知道这个分配的地址是多少，因此当我们在对这样动态链接的代码进行调试的时候，需要手动要求gdb将调试信息加载到指定地址。

下面，我们要求gdb将linker加载到0x6fee6180这个地址上：

	(gdb) add-symbol-file android_test/system/bin/linker 0x6fee6180

这样的命令默认是将代码段(.data)段的调试信息加载到0x6fee6180上，当然，你也可以通过“-s”这个参数来指定，比如：
	(gdb) add-symbol-file android_test/system/bin/linker –s .text 0x6fee6180

这样，在执行到linker中代码时gdb就能够显示出正确的代码和调试信息出来。

这个方法在操作系统中调试动态链接器时特别有用。