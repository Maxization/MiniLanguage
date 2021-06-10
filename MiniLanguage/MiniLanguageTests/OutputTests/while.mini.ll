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
%k_2 = alloca i32
%i_3 = alloca i32
%j_4 = alloca i32
%squares_5 = alloca i32
store i32 0, i32* %int
%tmp_1 = load i32, i32* %int
store i32 %tmp_1, i32* %squares_5
%tmp_2 = load i32, i32* %squares_5
store i32 %tmp_2, i32* %j_4
%tmp_3 = load i32, i32* %j_4
store i32 %tmp_3, i32* %i_3
%tmp_4 = load i32, i32* %i_3
store i32 1, i32* %int
%tmp_5 = load i32, i32* %int
store i32 %tmp_5, i32* %n_1
%tmp_6 = load i32, i32* %n_1
store i32 8, i32* %int
%tmp_7 = load i32, i32* %int
store i32 %tmp_7, i32* %k_2
%tmp_8 = load i32, i32* %k_2
br label %LABEL_1
LABEL_1:
%tmp_9 = load i32, i32* %k_2
store i32 1, i32* %int
%tmp_10 = load i32, i32* %int
%tmp_11 = icmp sge i32 %tmp_9, %tmp_10
br i1 %tmp_11, label %LABEL_2, label %LABEL_3
LABEL_2:
%tmp_12 = load i32, i32* %n_1
%tmp_13 = load i32, i32* %k_2
%tmp_14 = mul i32 %tmp_12, %tmp_13
store i32 %tmp_14, i32* %n_1
%tmp_15 = load i32, i32* %n_1
%tmp_16 = load i32, i32* %k_2
store i32 1, i32* %int
%tmp_17 = load i32, i32* %int
%tmp_18 = sub i32 %tmp_16, %tmp_17
store i32 %tmp_18, i32* %k_2
%tmp_19 = load i32, i32* %k_2
br label %LABEL_1
LABEL_3:
%tmp_20 = load i32, i32* %n_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_20)
%tmp_74 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_74
%tmp_75 = bitcast [2 x i8]* %tmp_74 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_75)
store i32 0, i32* %int
%tmp_21 = load i32, i32* %int
store i32 %tmp_21, i32* %n_1
%tmp_22 = load i32, i32* %n_1
br label %LABEL_4
LABEL_4:
%tmp_23 = load i32, i32* %n_1
store i32 5, i32* %int
%tmp_24 = load i32, i32* %int
%tmp_25 = icmp slt i32 %tmp_23, %tmp_24
br i1 %tmp_25, label %LABEL_5, label %LABEL_6
LABEL_5:
%tmp_26 = load i32, i32* %n_1
store i32 1, i32* %int
%tmp_27 = load i32, i32* %int
%tmp_28 = add i32 %tmp_26, %tmp_27
store i32 %tmp_28, i32* %n_1
%tmp_29 = load i32, i32* %n_1
%tmp_30 = load i32, i32* %n_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_30)
%tmp_76 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_76
%tmp_77 = bitcast [2 x i8]* %tmp_76 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_77)
br label %LABEL_4
LABEL_6:
br label %LABEL_7
LABEL_7:
%tmp_31 = load i32, i32* %i_3
store i32 3, i32* %int
%tmp_32 = load i32, i32* %int
%tmp_33 = icmp slt i32 %tmp_31, %tmp_32
br i1 %tmp_33, label %LABEL_8, label %LABEL_9
LABEL_8:
br label %LABEL_10
LABEL_10:
%tmp_34 = load i32, i32* %j_4
store i32 3, i32* %int
%tmp_35 = load i32, i32* %int
%tmp_36 = icmp slt i32 %tmp_34, %tmp_35
br i1 %tmp_36, label %LABEL_11, label %LABEL_12
LABEL_11:
%tmp_37 = load i32, i32* %squares_5
%tmp_38 = load i32, i32* %i_3
%tmp_39 = load i32, i32* %j_4
%tmp_40 = mul i32 %tmp_38, %tmp_39
%tmp_41 = add i32 %tmp_37, %tmp_40
store i32 %tmp_41, i32* %squares_5
%tmp_42 = load i32, i32* %squares_5
%tmp_43 = load i32, i32* %j_4
store i32 1, i32* %int
%tmp_44 = load i32, i32* %int
%tmp_45 = add i32 %tmp_43, %tmp_44
store i32 %tmp_45, i32* %j_4
%tmp_46 = load i32, i32* %j_4
br label %LABEL_10
LABEL_12:
%tmp_47 = load i32, i32* %i_3
store i32 1, i32* %int
%tmp_48 = load i32, i32* %int
%tmp_49 = add i32 %tmp_47, %tmp_48
store i32 %tmp_49, i32* %i_3
%tmp_50 = load i32, i32* %i_3
store i32 0, i32* %int
%tmp_51 = load i32, i32* %int
store i32 %tmp_51, i32* %j_4
%tmp_52 = load i32, i32* %j_4
br label %LABEL_7
LABEL_9:
%tmp_53 = load i32, i32* %squares_5
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_53)
%tmp_78 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_78
%tmp_79 = bitcast [2 x i8]* %tmp_78 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_79)
store i32 3, i32* %int
%tmp_54 = load i32, i32* %int
store i32 %tmp_54, i32* %i_3
%tmp_55 = load i32, i32* %i_3
store i32 5, i32* %int
%tmp_56 = load i32, i32* %int
store i32 %tmp_56, i32* %j_4
%tmp_57 = load i32, i32* %j_4
br label %LABEL_13
LABEL_13:
%tmp_58 = load i32, i32* %i_3
store i32 0, i32* %int
%tmp_59 = load i32, i32* %int
%tmp_60 = icmp sgt i32 %tmp_58, %tmp_59
br i1 %tmp_60, label %LABEL_14, label %LABEL_15
LABEL_14:
br label %LABEL_16
LABEL_16:
%tmp_61 = load i32, i32* %j_4
store i32 0, i32* %int
%tmp_62 = load i32, i32* %int
%tmp_63 = icmp sgt i32 %tmp_61, %tmp_62
br i1 %tmp_63, label %LABEL_17, label %LABEL_18
LABEL_17:
%tmp_64 = load i32, i32* %i_3
store i32 1, i32* %int
%tmp_65 = load i32, i32* %int
%tmp_66 = sub i32 %tmp_64, %tmp_65
store i32 %tmp_66, i32* %i_3
%tmp_67 = load i32, i32* %i_3
%tmp_68 = load i32, i32* %j_4
store i32 1, i32* %int
%tmp_69 = load i32, i32* %int
%tmp_70 = sub i32 %tmp_68, %tmp_69
store i32 %tmp_70, i32* %j_4
%tmp_71 = load i32, i32* %j_4
br label %LABEL_16
LABEL_18:
br label %LABEL_13
LABEL_15:
%tmp_72 = load i32, i32* %i_3
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_72)
%tmp_80 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_80
%tmp_81 = bitcast [2 x i8]* %tmp_80 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_81)
%tmp_73 = load i32, i32* %j_4
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_73)
ret i32 0
}
