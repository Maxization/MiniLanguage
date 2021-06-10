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
%a_1 = alloca double
%m_2 = alloca double
%seed_3 = alloca double
%x_4 = alloca double
%y_5 = alloca double
%i_6 = alloca i32
%iters_7 = alloca i32
%inside_8 = alloca i32
%pi_9 = alloca double
store i32 123456789, i32* %int
%tmp_1 = load i32, i32* %int
%tmp_83 = uitofp i32 %tmp_1 to double
store double %tmp_83, double* %seed_3
%tmp_2 = load double, double* %seed_3
store i32 48271, i32* %int
%tmp_3 = load i32, i32* %int
%tmp_84 = uitofp i32 %tmp_3 to double
store double %tmp_84, double* %a_1
%tmp_4 = load double, double* %a_1
store i32 2147483647, i32* %int
%tmp_5 = load i32, i32* %int
%tmp_85 = uitofp i32 %tmp_5 to double
store double %tmp_85, double* %m_2
%tmp_6 = load double, double* %m_2
store i32 0, i32* %int
%tmp_7 = load i32, i32* %int
store i32 %tmp_7, i32* %i_6
%tmp_8 = load i32, i32* %i_6
store i32 %tmp_8, i32* %inside_8
%tmp_9 = load i32, i32* %inside_8
store i32 1000, i32* %int
%tmp_10 = load i32, i32* %int
store i32 %tmp_10, i32* %iters_7
%tmp_11 = load i32, i32* %iters_7
br label %LABEL_1
LABEL_1:
%tmp_12 = load i32, i32* %i_6
%tmp_13 = load i32, i32* %iters_7
%tmp_14 = icmp slt i32 %tmp_12, %tmp_13
br i1 %tmp_14, label %LABEL_2, label %LABEL_3
LABEL_2:
%tmp_15 = load double, double* %a_1
%tmp_16 = load double, double* %seed_3
%tmp_17 = fmul double %tmp_15, %tmp_16
store double %tmp_17, double* %seed_3
%tmp_18 = load double, double* %seed_3
br label %LABEL_4
LABEL_4:
%tmp_19 = load double, double* %seed_3
%tmp_20 = load double, double* %m_2
%tmp_21 = fcmp ogt double %tmp_19, %tmp_20
br i1 %tmp_21, label %LABEL_5, label %LABEL_6
LABEL_5:
%tmp_22 = load double, double* %seed_3
%tmp_23 = load double, double* %m_2
%tmp_24 = fsub double %tmp_22, %tmp_23
store double %tmp_24, double* %seed_3
%tmp_25 = load double, double* %seed_3
br label %LABEL_4
LABEL_6:
store i32 2, i32* %int
%tmp_26 = load i32, i32* %int
%tmp_27 = load double, double* %seed_3
%tmp_86 = uitofp i32 %tmp_26 to double
%tmp_28 = fmul double %tmp_86, %tmp_27
%tmp_29 = load double, double* %m_2
%tmp_30 = fdiv double %tmp_28, %tmp_29
store i32 1, i32* %int
%tmp_31 = load i32, i32* %int
%tmp_87 = uitofp i32 %tmp_31 to double
%tmp_32 = fsub double %tmp_30, %tmp_87
store double %tmp_32, double* %x_4
%tmp_33 = load double, double* %x_4
%tmp_34 = load double, double* %a_1
%tmp_35 = load double, double* %seed_3
%tmp_36 = fmul double %tmp_34, %tmp_35
store double %tmp_36, double* %seed_3
%tmp_37 = load double, double* %seed_3
br label %LABEL_7
LABEL_7:
%tmp_38 = load double, double* %seed_3
%tmp_39 = load double, double* %m_2
%tmp_40 = fcmp ogt double %tmp_38, %tmp_39
br i1 %tmp_40, label %LABEL_8, label %LABEL_9
LABEL_8:
%tmp_41 = load double, double* %seed_3
%tmp_42 = load double, double* %m_2
%tmp_43 = fsub double %tmp_41, %tmp_42
store double %tmp_43, double* %seed_3
%tmp_44 = load double, double* %seed_3
br label %LABEL_7
LABEL_9:
store i32 2, i32* %int
%tmp_45 = load i32, i32* %int
%tmp_46 = load double, double* %seed_3
%tmp_88 = uitofp i32 %tmp_45 to double
%tmp_47 = fmul double %tmp_88, %tmp_46
%tmp_48 = load double, double* %m_2
%tmp_49 = fdiv double %tmp_47, %tmp_48
store i32 1, i32* %int
%tmp_50 = load i32, i32* %int
%tmp_89 = uitofp i32 %tmp_50 to double
%tmp_51 = fsub double %tmp_49, %tmp_89
store double %tmp_51, double* %y_5
%tmp_52 = load double, double* %y_5
%tmp_53 = load double, double* %x_4
%tmp_54 = load double, double* %x_4
%tmp_55 = fmul double %tmp_53, %tmp_54
%tmp_56 = load double, double* %y_5
%tmp_57 = load double, double* %y_5
%tmp_58 = fmul double %tmp_56, %tmp_57
%tmp_59 = fadd double %tmp_55, %tmp_58
store i32 1, i32* %int
%tmp_60 = load i32, i32* %int
%tmp_90 = uitofp i32 %tmp_60 to double
%tmp_61 = fcmp ole double %tmp_59, %tmp_90
br i1 %tmp_61, label %LABEL_10, label %LABEL_11
LABEL_10:
%tmp_62 = load i32, i32* %inside_8
store i32 1, i32* %int
%tmp_63 = load i32, i32* %int
%tmp_64 = add i32 %tmp_62, %tmp_63
store i32 %tmp_64, i32* %inside_8
%tmp_65 = load i32, i32* %inside_8
br label %LABEL_12
LABEL_11:
br label %LABEL_12
LABEL_12:
%tmp_66 = load i32, i32* %i_6
store i32 1, i32* %int
%tmp_67 = load i32, i32* %int
%tmp_68 = add i32 %tmp_66, %tmp_67
store i32 %tmp_68, i32* %i_6
%tmp_69 = load i32, i32* %i_6
br label %LABEL_1
LABEL_3:
store double 4.0, double* %double
%tmp_70 = load double, double* %double
%tmp_71 = load i32, i32* %inside_8
%tmp_91 = uitofp i32 %tmp_71 to double
%tmp_72 = fmul double %tmp_70, %tmp_91
%tmp_73 = load i32, i32* %iters_7
%tmp_92 = uitofp i32 %tmp_73 to double
%tmp_74 = fdiv double %tmp_72, %tmp_92
store double %tmp_74, double* %pi_9
%tmp_75 = load double, double* %pi_9
%tmp_93 = alloca [23 x i8]
store [23 x i8] c"PI between 3 and 3.3: \00", [23 x i8]* %tmp_93
%tmp_94 = bitcast [23 x i8]* %tmp_93 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_94)
%tmp_76 = load double, double* %pi_9
store i32 3, i32* %int
%tmp_77 = load i32, i32* %int
%tmp_95 = uitofp i32 %tmp_77 to double
%tmp_78 = fcmp ogt double %tmp_76, %tmp_95
br i1 %tmp_78, label %LABEL_13, label %LABEL_14
LABEL_14:
store i1 0, i1* %bool
br label %LABEL_15
LABEL_13:
%tmp_79 = load double, double* %pi_9
store double 3.3, double* %double
%tmp_80 = load double, double* %double
%tmp_81 = fcmp olt double %tmp_79, %tmp_80
%tmp_96 = and i1 %tmp_78, %tmp_81
store i1 %tmp_96, i1* %bool
br label %LABEL_15
LABEL_15:
%tmp_82 = load i1, i1* %bool
br i1 %tmp_82, label %LABEL_16, label %LABEL_17
LABEL_16:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_18
LABEL_17:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_18
LABEL_18:
ret i32 0
}
