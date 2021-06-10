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
%g_2 = alloca i32
%k_3 = alloca double
store i32 9, i32* %int
%tmp_172 = load i32, i32* %int
store i32 6, i32* %int
%tmp_173 = load i32, i32* %int
%tmp_174 = or i32 %tmp_172, %tmp_173
store i32 %tmp_174, i32* %x_1
%tmp_175 = load i32, i32* %x_1
%tmp_176 = load i32, i32* %x_1
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_176)
%tmp_200 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_200
%tmp_201 = bitcast [2 x i8]* %tmp_200 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_201)
store i32 105, i32* %int
%tmp_177 = load i32, i32* %int
store i32 184, i32* %int
%tmp_178 = load i32, i32* %int
%tmp_179 = and i32 %tmp_177, %tmp_178
%tmp_202 = uitofp i32 %tmp_179 to double
store double %tmp_202, double* %k_3
%tmp_180 = load double, double* %k_3
%tmp_181 = load double, double* %k_3
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_181)
%tmp_203 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_203
%tmp_204 = bitcast [2 x i8]* %tmp_203 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_204)
store i32 1, i32* %int
%tmp_182 = load i32, i32* %int
store i32 2, i32* %int
%tmp_183 = load i32, i32* %int
store i32 3, i32* %int
%tmp_184 = load i32, i32* %int
%tmp_185 = or i32 %tmp_183, %tmp_184
%tmp_186 = add i32 %tmp_182, %tmp_185
store i32 4, i32* %int
%tmp_187 = load i32, i32* %int
%tmp_188 = sub i32 %tmp_186, %tmp_187
store i32 %tmp_188, i32* %g_2
%tmp_189 = load i32, i32* %g_2
%tmp_190 = load i32, i32* %g_2
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_190)
%tmp_205 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_205
%tmp_206 = bitcast [2 x i8]* %tmp_205 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_206)
store i32 1, i32* %int
%tmp_191 = load i32, i32* %int
store i32 2, i32* %int
%tmp_192 = load i32, i32* %int
%tmp_193 = or i32 %tmp_191, %tmp_192
store i32 8, i32* %int
%tmp_194 = load i32, i32* %int
store i32 4, i32* %int
%tmp_195 = load i32, i32* %int
%tmp_196 = and i32 %tmp_194, %tmp_195
%tmp_197 = add i32 %tmp_193, %tmp_196
store i32 %tmp_197, i32* %g_2
%tmp_198 = load i32, i32* %g_2
%tmp_199 = load i32, i32* %g_2
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_199)
ret i32 0
}
