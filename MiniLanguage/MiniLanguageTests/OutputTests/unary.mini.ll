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
store i32 1, i32* %int
%tmp_1 = load i32, i32* %int
%tmp_2 = sub i32 0, %tmp_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_2)
%tmp_32 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_32
%tmp_33 = bitcast [2 x i8]* %tmp_32 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_33)
store i32 5, i32* %int
%tmp_3 = load i32, i32* %int
%tmp_4 = sub i32 0, %tmp_3
%tmp_5 = sub i32 0, %tmp_4
%tmp_6 = sub i32 0, %tmp_5
%tmp_7 = sub i32 0, %tmp_6
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_7)
%tmp_34 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_34
%tmp_35 = bitcast [2 x i8]* %tmp_34 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_35)
store i1 1, i1* %bool
%tmp_8 = load i1, i1* %bool
%tmp_9 = xor i1 %tmp_8, 1
br i1 %tmp_9, label %LABEL_1, label %LABEL_2
LABEL_1:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_3
LABEL_2:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_3
LABEL_3:
%tmp_36 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_36
%tmp_37 = bitcast [2 x i8]* %tmp_36 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_37)
store i1 1, i1* %bool
%tmp_10 = load i1, i1* %bool
%tmp_11 = xor i1 %tmp_10, 1
%tmp_12 = xor i1 %tmp_11, 1
br i1 %tmp_12, label %LABEL_4, label %LABEL_5
LABEL_4:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_6
LABEL_5:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_6
LABEL_6:
%tmp_38 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_38
%tmp_39 = bitcast [2 x i8]* %tmp_38 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_39)
store i32 1, i32* %int
%tmp_13 = load i32, i32* %int
%tmp_14 = xor i32 %tmp_13, -1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_14)
%tmp_40 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_40
%tmp_41 = bitcast [2 x i8]* %tmp_40 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_41)
store i32 2, i32* %int
%tmp_15 = load i32, i32* %int
%tmp_16 = sub i32 0, %tmp_15
%tmp_17 = xor i32 %tmp_16, -1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_17)
%tmp_42 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_42
%tmp_43 = bitcast [2 x i8]* %tmp_42 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_43)
store double 3.56, double* %double
%tmp_18 = load double, double* %double
%tmp_19 = fadd double %tmp_18, 0.0
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_19)
%tmp_44 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_44
%tmp_45 = bitcast [2 x i8]* %tmp_44 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_45)
store i32 8, i32* %int
%tmp_20 = load i32, i32* %int
%tmp_21 = sitofp i32 %tmp_20 to double
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_21)
%tmp_46 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_46
%tmp_47 = bitcast [2 x i8]* %tmp_46 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_47)
store i32 5, i32* %int
%tmp_22 = load i32, i32* %int
%tmp_23 = add i32 %tmp_22, 0
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_23)
%tmp_48 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_48
%tmp_49 = bitcast [2 x i8]* %tmp_48 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_49)
store double 1.4, double* %double
%tmp_24 = load double, double* %double
%tmp_25 = fptosi double %tmp_24 to i32
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_25)
%tmp_50 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_50
%tmp_51 = bitcast [2 x i8]* %tmp_50 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_51)
store double 3.89, double* %double
%tmp_26 = load double, double* %double
%tmp_27 = fptosi double %tmp_26 to i32
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_27)
%tmp_52 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_52
%tmp_53 = bitcast [2 x i8]* %tmp_52 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_53)
store i1 1, i1* %bool
%tmp_28 = load i1, i1* %bool
%tmp_29 = zext i1 %tmp_28 to i32
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_29)
%tmp_54 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_54
%tmp_55 = bitcast [2 x i8]* %tmp_54 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_55)
store i1 0, i1* %bool
%tmp_30 = load i1, i1* %bool
%tmp_31 = zext i1 %tmp_30 to i32
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_31)
ret i32 0
}
