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
%tmp_1 = alloca [2 x i8]
store [2 x i8] c"\5C\00", [2 x i8]* %tmp_1
%tmp_2 = bitcast [2 x i8]* %tmp_1 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_2)
%tmp_3 = alloca [2 x i8]
store [2 x i8] c"\22\00", [2 x i8]* %tmp_3
%tmp_4 = bitcast [2 x i8]* %tmp_3 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_4)
%tmp_5 = alloca [2 x i8]
store [2 x i8] c"\0A\00", [2 x i8]* %tmp_5
%tmp_6 = bitcast [2 x i8]* %tmp_5 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_6)
%tmp_7 = alloca [2 x i8]
store [2 x i8] c"?\00", [2 x i8]* %tmp_7
%tmp_8 = bitcast [2 x i8]* %tmp_7 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_8)
ret i32 0
}
