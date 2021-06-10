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
%x_1 = alloca i32
%y_2 = alloca i32
%d_3 = alloca double
store i32 6, i32* %int
%tmp_447 = load i32, i32* %int
store i32 %tmp_447, i32* %y_2
%tmp_448 = load i32, i32* %y_2
store i32 %tmp_448, i32* %x_1
%tmp_449 = load i32, i32* %x_1
%tmp_454 = uitofp i32 %tmp_449 to double
store double %tmp_454, double* %d_3
%tmp_450 = load double, double* %d_3
%tmp_451 = load i32, i32* %x_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_451)
%tmp_455 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_455
%tmp_456 = bitcast [2 x i8]* %tmp_455 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_456)
%tmp_452 = load i32, i32* %y_2
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_452)
%tmp_457 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_457
%tmp_458 = bitcast [2 x i8]* %tmp_457 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_458)
%tmp_453 = load double, double* %d_3
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_453)
ret i32 0
}
