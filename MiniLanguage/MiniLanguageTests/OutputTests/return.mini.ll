; prolog
@int_res = constant [3 x i8] c"%d\00"
@hex_res = constant [5 x i8] c"0X%X\00"
@double_res = constant [4 x i8] c"%lf\00"
@true_res = constant [5 x i8] c"True\00"
@false_res = constant [6 x i8] c"False\00"
@int_read = constant [ 3 x i8] c"%d\00"
@hex_read = constant [3 x i8] c"%X\00"
@double_read = constant [ 4 x i8] c"%lf\00"
declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)
define i32 @main()
{
%int = alloca i32
%double = alloca double
%bool = alloca i1
%tmp_123 = alloca [7 x i8]
store [7 x i8] c"return\00", [7 x i8]* %tmp_123
%tmp_124 = bitcast [7 x i8]* %tmp_123 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_124)
ret i32 0
%tmp_125 = alloca [31 x i8]
store [31 x i8] c"this should not be written out\00", [31 x i8]* %tmp_125
%tmp_126 = bitcast [31 x i8]* %tmp_125 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_126)
ret i32 0
}
