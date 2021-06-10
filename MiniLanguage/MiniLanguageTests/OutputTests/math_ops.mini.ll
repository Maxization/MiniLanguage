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
%k_1 = alloca double
%k2_2 = alloca double
%what_3 = alloca double
store i32 1, i32* %int
%tmp_287 = load i32, i32* %int
store i32 2, i32* %int
%tmp_288 = load i32, i32* %int
%tmp_289 = add i32 %tmp_287, %tmp_288
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_289)
%tmp_348 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_348
%tmp_349 = bitcast [2 x i8]* %tmp_348 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_349)
store i32 1, i32* %int
%tmp_290 = load i32, i32* %int
store i32 2, i32* %int
%tmp_291 = load i32, i32* %int
%tmp_292 = sub i32 %tmp_290, %tmp_291
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_292)
%tmp_350 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_350
%tmp_351 = bitcast [2 x i8]* %tmp_350 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_351)
store i32 1, i32* %int
%tmp_293 = load i32, i32* %int
store i32 2, i32* %int
%tmp_294 = load i32, i32* %int
%tmp_295 = mul i32 %tmp_293, %tmp_294
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_295)
%tmp_352 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_352
%tmp_353 = bitcast [2 x i8]* %tmp_352 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_353)
store i32 1, i32* %int
%tmp_296 = load i32, i32* %int
store i32 2, i32* %int
%tmp_297 = load i32, i32* %int
%tmp_298 = sdiv i32 %tmp_296, %tmp_297
%tmp_354 = uitofp i32 %tmp_298 to double
store double %tmp_354, double* %k_1
%tmp_299 = load double, double* %k_1
%tmp_300 = load double, double* %k_1
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_300)
%tmp_355 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_355
%tmp_356 = bitcast [2 x i8]* %tmp_355 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_356)
store i32 1, i32* %int
%tmp_301 = load i32, i32* %int
store double 2.0, double* %double
%tmp_302 = load double, double* %double
%tmp_357 = uitofp i32 %tmp_301 to double
%tmp_303 = fdiv double %tmp_357, %tmp_302
store double %tmp_303, double* %k2_2
%tmp_304 = load double, double* %k2_2
%tmp_305 = load double, double* %k2_2
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_305)
%tmp_358 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_358
%tmp_359 = bitcast [2 x i8]* %tmp_358 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_359)
store double 1.0, double* %double
%tmp_306 = load double, double* %double
store i32 2, i32* %int
%tmp_307 = load i32, i32* %int
%tmp_360 = uitofp i32 %tmp_307 to double
%tmp_308 = fmul double %tmp_306, %tmp_360
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_308)
%tmp_361 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_361
%tmp_362 = bitcast [2 x i8]* %tmp_361 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_362)
store i32 2, i32* %int
%tmp_309 = load i32, i32* %int
store i32 2, i32* %int
%tmp_310 = load i32, i32* %int
store i32 2, i32* %int
%tmp_311 = load i32, i32* %int
%tmp_312 = mul i32 %tmp_310, %tmp_311
%tmp_313 = add i32 %tmp_309, %tmp_312
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_313)
%tmp_363 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_363
%tmp_364 = bitcast [2 x i8]* %tmp_363 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_364)
store i32 1, i32* %int
%tmp_314 = load i32, i32* %int
store i32 0, i32* %int
%tmp_315 = load i32, i32* %int
%tmp_316 = add i32 %tmp_314, %tmp_315
store double 1.0, double* %double
%tmp_317 = load double, double* %double
%tmp_365 = uitofp i32 %tmp_316 to double
%tmp_318 = fadd double %tmp_365, %tmp_317
store i32 2, i32* %int
%tmp_319 = load i32, i32* %int
%tmp_366 = uitofp i32 %tmp_319 to double
%tmp_320 = fadd double %tmp_318, %tmp_366
store i32 3, i32* %int
%tmp_321 = load i32, i32* %int
%tmp_367 = uitofp i32 %tmp_321 to double
%tmp_322 = fmul double %tmp_320, %tmp_367
store i32 4, i32* %int
%tmp_323 = load i32, i32* %int
%tmp_368 = uitofp i32 %tmp_323 to double
%tmp_324 = fdiv double %tmp_322, %tmp_368
store i32 5, i32* %int
%tmp_325 = load i32, i32* %int
%tmp_369 = uitofp i32 %tmp_325 to double
%tmp_326 = fsub double %tmp_324, %tmp_369
store double %tmp_326, double* %what_3
%tmp_327 = load double, double* %what_3
%tmp_328 = load double, double* %what_3
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_328)
%tmp_370 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_370
%tmp_371 = bitcast [2 x i8]* %tmp_370 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_371)
store i32 1, i32* %int
%tmp_329 = load i32, i32* %int
store i32 2, i32* %int
%tmp_330 = load i32, i32* %int
%tmp_331 = mul i32 %tmp_329, %tmp_330
store i32 3, i32* %int
%tmp_332 = load i32, i32* %int
%tmp_333 = add i32 %tmp_331, %tmp_332
store double 4.0, double* %double
%tmp_334 = load double, double* %double
store i32 5, i32* %int
%tmp_335 = load i32, i32* %int
%tmp_372 = uitofp i32 %tmp_335 to double
%tmp_336 = fmul double %tmp_334, %tmp_372
%tmp_373 = uitofp i32 %tmp_333 to double
%tmp_337 = fadd double %tmp_373, %tmp_336
call i32 (i8*, ...) @printf(i8* bitcast ([4 x i8]* @double_res to i8*), double %tmp_337)
%tmp_374 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_374
%tmp_375 = bitcast [2 x i8]* %tmp_374 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_375)
store i32 1, i32* %int
%tmp_338 = load i32, i32* %int
store i32 2, i32* %int
%tmp_339 = load i32, i32* %int
%tmp_340 = add i32 %tmp_338, %tmp_339
store i32 3, i32* %int
%tmp_341 = load i32, i32* %int
%tmp_342 = add i32 %tmp_340, %tmp_341
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_342)
%tmp_376 = alloca [2 x i8]
store [2 x i8] c" \00", [2 x i8]* %tmp_376
%tmp_377 = bitcast [2 x i8]* %tmp_376 to i8*
call i32 (i8*, ...) @printf(i8* %tmp_377)
store i32 1, i32* %int
%tmp_343 = load i32, i32* %int
store i32 2, i32* %int
%tmp_344 = load i32, i32* %int
%tmp_345 = mul i32 %tmp_343, %tmp_344
store i32 3, i32* %int
%tmp_346 = load i32, i32* %int
%tmp_347 = mul i32 %tmp_345, %tmp_346
call i32 (i8*, ...) @printf(i8* bitcast ([3 x i8]* @int_res to i8*), i32 %tmp_347)
ret i32 0
}
