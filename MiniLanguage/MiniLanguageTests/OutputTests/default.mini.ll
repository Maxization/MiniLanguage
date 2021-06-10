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
%d_2 = alloca double
%b_3 = alloca i1
store i32 0, i32* %int
%tmp_1 = load i32, i32* %int
store i32 %tmp_1, i32* %x_1
%tmp_2 = load i32, i32* %x_1
store i32 0, i32* %int
%tmp_3 = load i32, i32* %int
%tmp_10 = uitofp i32 %tmp_3 to double
store double %tmp_10, double* %d_2
%tmp_4 = load double, double* %d_2
store i1 0, i1* %bool
%tmp_5 = load i1, i1* %bool
store i1 %tmp_5, i1* %b_3
%tmp_6 = load i1, i1* %b_3
%tmp_7 = load i32, i32* %x_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_7)
%tmp_11 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_11
%tmp_12 = bitcast [2 x i8]* %tmp_11 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_12)
%tmp_8 = load double, double* %d_2
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_8)
%tmp_13 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_13
%tmp_14 = bitcast [2 x i8]* %tmp_13 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_14)
%tmp_9 = load i1, i1* %b_3
br i1 %tmp_9, label %LABEL_1, label %LABEL_2
LABEL_1:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_3
LABEL_2:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_3
LABEL_3:
ret i32 0
}
