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
%n_1 = alloca i32
%iters_2 = alloca i32
store i32 7, i32* %int
%tmp_1 = load i32, i32* %int
store i32 %tmp_1, i32* %n_1
%tmp_2 = load i32, i32* %n_1
store i32 0, i32* %int
%tmp_3 = load i32, i32* %int
store i32 %tmp_3, i32* %iters_2
%tmp_4 = load i32, i32* %iters_2
br label %LABEL_1
LABEL_1:
%tmp_5 = load i32, i32* %n_1
store i32 1, i32* %int
%tmp_6 = load i32, i32* %int
%tmp_7 = icmp ne i32 %tmp_5, %tmp_6
br i1 %tmp_7, label %LABEL_2, label %LABEL_3
LABEL_2:
%tmp_8 = load i32, i32* %n_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_8)
%tmp_29 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_29
%tmp_30 = bitcast [2 x i8]* %tmp_29 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_30)
%tmp_9 = load i32, i32* %n_1
store i32 1, i32* %int
%tmp_10 = load i32, i32* %int
%tmp_11 = and i32 %tmp_9, %tmp_10
store i32 1, i32* %int
%tmp_12 = load i32, i32* %int
%tmp_13 = icmp eq i32 %tmp_11, %tmp_12
br i1 %tmp_13, label %LABEL_4, label %LABEL_5
LABEL_4:
store i32 3, i32* %int
%tmp_14 = load i32, i32* %int
%tmp_15 = load i32, i32* %n_1
%tmp_16 = mul i32 %tmp_14, %tmp_15
store i32 1, i32* %int
%tmp_17 = load i32, i32* %int
%tmp_18 = add i32 %tmp_16, %tmp_17
store i32 %tmp_18, i32* %n_1
%tmp_19 = load i32, i32* %n_1
br label %LABEL_6
LABEL_5:
%tmp_20 = load i32, i32* %n_1
store i32 2, i32* %int
%tmp_21 = load i32, i32* %int
%tmp_22 = sdiv i32 %tmp_20, %tmp_21
store i32 %tmp_22, i32* %n_1
%tmp_23 = load i32, i32* %n_1
br label %LABEL_6
LABEL_6:
%tmp_24 = load i32, i32* %iters_2
store i32 1, i32* %int
%tmp_25 = load i32, i32* %int
%tmp_26 = add i32 %tmp_24, %tmp_25
store i32 %tmp_26, i32* %iters_2
%tmp_27 = load i32, i32* %iters_2
br label %LABEL_1
LABEL_3:
%tmp_31 = alloca [8 x i8]
store [8 x i8] c"iters: \00", [8 x i8]* %tmp_31
%tmp_32 = bitcast [8 x i8]* %tmp_31 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_32)
%tmp_28 = load i32, i32* %iters_2
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_28)
ret i32 0
}
