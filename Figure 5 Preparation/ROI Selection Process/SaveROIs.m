clear;close all;clc

ROI{1}{1}=[1 95 97 245];
ROI{1}{2}=[51 210 186 344];

ROI{2}{1}=[21 191 113 283];
ROI{2}{2}=[8 130 277 399];
ROI{2}{3}=[216 356 270 429];
ROI{2}{4}=[304 420 237 353];

ROI{3}{1}=[156 295 233 372];
ROI{3}{2}=[171 305 1 123];
ROI{3}{3}=[338 467 185 314];
ROI{3}{4}=[416 546 127 257];

ROI{4}{1}=[1 108 374 512];
ROI{4}{2}=[265 373 195 349];
ROI{4}{3}=[359 498 159 298];

ROI{5}{1}=[57 199 152 293];
ROI{5}{2}=[178 336 152 310];
ROI{5}{3}=[122 295 1 154];
ROI{5}{4}=[394 512 168 290];

ROI{6}{1}=[398 512 207 356];

ROI{7}{1}=[117 244 210 336];
ROI{7}{2}=[5 122 30 147];
ROI{7}{3}=[215 335 17 137];
ROI{7}{4}=[398 512 121 235];

ROI{8}{1}=[77 211 10 144];
ROI{8}{2}=[37 221 309 493];
ROI{8}{3}=[236 382 182 329];
ROI{8}{4}=[293 445 310 400];

ROI{9}{1}=[1 122 225 386];

ROI{10}{1}=[75 242 123 290];
ROI{10}{2}=[380 512 316 448];
ROI{10}{3}=[42 148 427 512];
ROI{10}{4}=[147 230 434 512];

ROI{11}{1}=[1 132 56 187];
ROI{11}{2}=[147 251 63 167];
ROI{11}{3}=[260 400 95 235];
ROI{11}{4}=[92 247 162 316];
ROI{11}{5}=[64 234 318 488];
ROI{11}{6}=[207 357 289 439];

ROI{12}{1}=[1 146 143 288];
ROI{12}{2}=[111 257 82 227];
ROI{12}{3}=[299 423 225 349];
ROI{12}{4}=[174 323 433 512];
ROI{12}{5}=[107 257 1 101];

ROI{13}{1}=[251 480 363 512];
ROI{13}{2}=[1 107 242 398];
ROI{13}{3}=[167 329 18 179];

ROI{14}{1}=[18 158 196 335];
ROI{14}{2}=[155 313 28 186];
ROI{14}{3}=[201 330 376 505];
ROI{14}{4}=[217 338 266 387];

ROI{15}{1}=[127 326 174 373];
ROI{15}{2}=[285 427 48 190];
ROI{15}{3}=[1 97 304 449];

ROI{16}{1}=[1 84 140 285];

ROI{17}{1}=[298 445 287 434];
ROI{17}{2}=[48 181 373 506];
ROI{17}{3}=[317 438 421 512];
ROI{17}{4}=[185 305 153 273];

ROI{18}{1}=[56 228 49 221];

ROI{19}{1}=[358 492 181 315];

ROI{20}{1}=[156 246 258 348];
ROI{20}{2}=[8 164 133 289];
ROI{20}{3}=[1 78 7 144];

ROI{21}{1}=[398 502 335 439];
ROI{21}{2}=[158 322 31 195];
ROI{21}{3}=[300 417 130 247];

ROI{22}{1}=[197 396 43 242];
ROI{22}{2}=[143 317 349 512];
ROI{22}{3}=[99 250 276 427];

ROI{23}{1}=[190 319 206 336];
ROI{23}{2}=[200 309 20 128];
ROI{23}{3}=[1 132 289 470];

ROI{24}{1}=[14 144 96 226];
ROI{24}{2}=[225 386 252 413];
ROI{24}{3}=[1 85 402 512];

ROI{25}{1}=[130 297 47 214];
ROI{25}{2}=[192 319 184 312];

ROI{26}{1}=[72 194 122 244];
ROI{26}{2}=[270 466 1 162];
ROI{26}{3}=[351 512 225 387];
ROI{26}{4}=[5 182 383 512];
ROI{26}{5}=[381 512 373 505];

save('ROIs.mat','ROI')