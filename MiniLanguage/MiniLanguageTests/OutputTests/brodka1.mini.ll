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
%i_1 = alloca i32
%d_2 = alloca double
%b_3 = alloca i1
store i32 5, i32* %int
%tmp_272 = load i32, i32* %int
store i32 %tmp_272, i32* %i_1
%tmp_273 = load i32, i32* %i_1
store double 123.456, double* %double
%tmp_274 = load double, double* %double
store double %tmp_274, double* %d_2
%tmp_275 = load double, double* %d_2
store i1 1, i1* %bool
%tmp_276 = load i1, i1* %bool
store i1 %tmp_276, i1* %b_3
%tmp_277 = load i1, i1* %b_3
%tmp_278 = load i32, i32* %i_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_278)
%tmp_281 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_281
%tmp_282 = bitcast [2 x i8]* %tmp_281 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_282)
%tmp_279 = load double, double* %d_2
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_279)
%tmp_283 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_283
%tmp_284 = bitcast [2 x i8]* %tmp_283 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_284)
%tmp_280 = load i1, i1* %b_3
br i1 %tmp_280, label %LABEL_64, label %LABEL_65
LABEL_64:
call i32 (i8*, ...) @printf(i8* bitcast ([5 x i8]* @true_res to i8*))
br label %LABEL_66
LABEL_65:
call i32 (i8*, ...) @printf(i8* bitcast ([6 x i8]* @false_res to i8*))
br label %LABEL_66
LABEL_66:
%tmp_285 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_285
%tmp_286 = bitcast [2 x i8]* %tmp_285 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_286)
ret i32 0
}
