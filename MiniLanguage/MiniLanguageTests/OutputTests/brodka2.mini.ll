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
%x_2 = alloca i32
%y_3 = alloca i32
%a_4 = alloca i32
%b_5 = alloca i32
store i32 5, i32* %int
%tmp_94 = load i32, i32* %int
store i32 %tmp_94, i32* %b_5
%tmp_95 = load i32, i32* %b_5
store i32 5, i32* %int
%tmp_96 = load i32, i32* %int
store i32 %tmp_96, i32* %x_2
%tmp_97 = load i32, i32* %x_2
store i32 7, i32* %int
%tmp_98 = load i32, i32* %int
store i32 %tmp_98, i32* %y_3
%tmp_99 = load i32, i32* %y_3
store i32 1, i32* %int
%tmp_100 = load i32, i32* %int
store i32 %tmp_100, i32* %n_1
%tmp_101 = load i32, i32* %n_1
%tmp_102 = load i32, i32* %n_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_102)
%tmp_117 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_117
%tmp_118 = bitcast [2 x i8]* %tmp_117 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_118)
%tmp_103 = load i32, i32* %x_2
%tmp_104 = load i32, i32* %y_3
%tmp_105 = add i32 %tmp_103, %tmp_104
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_105)
%tmp_119 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_119
%tmp_120 = bitcast [2 x i8]* %tmp_119 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_120)
%tmp_106 = load i32, i32* %a_4
store i32 0, i32* %int
%tmp_107 = load i32, i32* %int
%tmp_108 = icmp sge i32 %tmp_106, %tmp_107
br i1 %tmp_108, label %LABEL_19, label %LABEL_20
LABEL_20:
store i1 0, i1* %bool
br label %LABEL_21
LABEL_19:
%tmp_109 = load i32, i32* %a_4
store i32 10, i32* %int
%tmp_110 = load i32, i32* %int
%tmp_111 = icmp slt i32 %tmp_109, %tmp_110
%tmp_121 = and i1 %tmp_108, %tmp_111
store i1 %tmp_121, i1* %bool
br label %LABEL_21
LABEL_21:
%tmp_112 = load i1, i1* %bool
br i1 %tmp_112, label %LABEL_22, label %LABEL_23
LABEL_22:
store i1 1, i1* %bool
br label %LABEL_24
LABEL_23:
%tmp_113 = load i32, i32* %b_5
store i32 3, i32* %int
%tmp_114 = load i32, i32* %int
%tmp_115 = icmp sgt i32 %tmp_113, %tmp_114
%tmp_122 = or i1 %tmp_112, %tmp_115
store i1 %tmp_122, i1* %bool
br label %LABEL_24
LABEL_24:
%tmp_116 = load i1, i1* %bool
br i1 %tmp_116, label %LABEL_25, label %LABEL_26
LABEL_25:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_27
LABEL_26:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_27
LABEL_27:
ret i32 0
}
