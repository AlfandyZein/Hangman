(* NIM/Nama	 	   : 1. 16511022/Azka Ihsan Nurrahman    *)
(*           		 2. 16511100/Renandhitya Fawzian     *)
(*          	     3. 16511172/Bima Laksmana Pramudita *)
(*           		 4. 16511250/M. Erwin Susetyo        *)
(*           		 5. 16511322/Kevin Verdi             *)
(* Nama File	   : TB_04_04.pas                        *)
(* Topik		   : Tugas Besar 						 *)
(* Tanggal 	 	   : 28 November 2011                    *)
(* Deskripsi 	   : Program ini adalah program peran tebak kata ( Hangman ) dengan spesifikasi yang telah diperintahkan, *)
(*                   di mana pada program utama terdapat modus persiapan game, modus tebak kata, dan modus untuk keluar   *)
(*                   dari program. Serta terdapat beberapa spesifikasi tambahan, seperti menu bantuan, dll.               *)
(* Pembagian Tugas : Azka mengerjakan prosedur display menu, prosedur help, edit prosedur login, dan program utama serta  *)
(*                   memberi komentar dan membuat daftar kata.	                                                          *)
(*                   Renand mengerjakan prosedur permainan tebak kata.                                                    *)
(*                   Bima mengerjakan prosedur permainan tebak kata, prosedur gambar hangman, fungsi status kemenangan,   *)
(*                   prosedur daftar kata, dan program utama                                                              *)
(*                   Erwin mengerjakan prosedur top ten, prosedur load daftar user dan save daftar user, prosedur view    *)
(*                   info, dan edit prosedur login serta prosedur permainan tebak kata                                    *)
(*                   Kevin mengerjakan prosedur login                                                                     *)

program hangman;
uses crt ;


//Source file diedit menggunakan notepad ++
//Program dikompilasi menggunakan free pascal 2.4.4
//Tes program terbaik dengan windows command prompt

(* ###################################### Kamus Global ###################################### *)

const
    JumlahKataMax = 100; (* Indeks Maksimum Jumlah Kata yang ditebak *)
	JumlahUserMax = 100; (* Indeks Maksimum Jumlah User yang dapat ditampung *)
	SalahMax = 8; (* Indeks maksimum jumlah kesalahan yang diperbolehkan dalam penebakan kata *)
	
type
	tdaftarkata = array [1..JumlahKataMax] of string ; (* Tabel daftar kata *)
	
	user = record (* Tipe User *)
		name : string ; (* Komponen Nama *)
		score : real ; (* Komponen Score *)
		katatertebak : tdaftarkata ; (* Komponen Kata yang pernah ditebak *)
		ntebakkata : integer; (* Komponen Jumlah Kata yang ditebak *)
		end;
	tdaftaruser = array [1..JumlahUserMax] of user ; (* Tabel daftar user *)
	
var
	daftaruser : tdaftaruser ; (* Variabel tampungan daftar pengguna *)
	nuser : integer ; (* Jumlah user *)
	daftarkata : tdaftarkata ; (* Variabel tampungan daftar kata *)
	topten : tdaftaruser ; (* Variabel tampungan skor 10 teratas *)
	useronline : integer ; (* User ke-n yang sedang memainkan game *)
	nkata : integer ; (* Kata ke-n yang dikeluarkan secara random dalam game tebak kata *)
	quit : boolean; (* Status pengecekan keluar program *)
	menu : integer ; (* Pilihan Menu *)

(* ################################### Akhir Kamus Global ################################### *)
	
(* ################################## Subprogram Pengguna ################################### *)

(* NIM/Nama : 16511250/M. Erwin Susetyo *)
procedure loaddaftaruser;
{I.S. : daftar user online belum terisi ( kosong ) }
{F.S. : daftar user online terisi }
var
	f : file of user;
begin
	assign(f, 'datauser.txt');
	reset(f);
	nuser := 0;
	while not eof(f) do
	begin
       	read(f, daftaruser[nuser+1]);
		nuser := nuser + 1;
	end;
	close (f);
end;

(* NIM/Nama : 16511250/M. Erwin Susetyo *)
procedure savedaftaruser;
{I.S. : daftar user belum tersimpan }
{F.S. : daftar user telah tersimpan }
var
	f : file of user;
	i : integer;
begin
	assign (f,'datauser.txt');
	rewrite (f);
	for i:=1 to nuser do
		write (f,daftaruser[i]);
	close (f);
end;

(* ################################ Akhir Subprogram Pengguna ################################## *)

(* ######################### Subprogram Login / Register / Change User ######################### *)

(* NIM / Nama : 1. 16511322/Kevin Verdi          *)
(*              2. 16511250/M. Erwin Susetyo     *)
(*              3. 16511022/Azka Ihsan Nurrahman *)
procedure login (var uonline : integer )  ;
(* Prosedur ini menangani modus login / register / change user sebelum pengguna memainkan *)
(* game tebak kata                                                                        *)
(* I.S : User belum Login / Register *)
(* F.S : User sudah Login / Register *)
	var (* Variabel Lokal *)
		j : integer;
		samename : boolean;
		tmp : user;
		idx : integer;
	begin
		clrscr ;
		repeat
			textbackground(lightblue);
			textcolor(white);
		    writeln;
		    writeln('###############################################################################');
	        writeln('###########################  Program HANGMAN  #################################');
	        writeln('###############################################################################');
	        writeln('############### Created by : Azka, Bima, Erwin, Kevin, Renand #################');
	        writeln('################### Copyright (C) 2011 All Rights Reserved ####################');
			writeln;
			write('Masukan Username Anda : '); readln(tmp.name);
		until (tmp.name <> '');
			j := 1;
			samename := false;	
			while (j<JumlahUserMax) and (not samename) do
				begin
					if (tmp.name = daftaruser[j].name) then
						begin
							samename := true;
							idx := j;
						end;
					j := j + 1;		
				end;
			if (samename) then
				begin	
					writeln ('Selamat Datang, ',tmp.name);
					writeln ('Silakan Melanjutkan Permainan Anda');
					writeln ('Tekan Enter untuk menuju ke Menu Utama ');
					uonline := idx;
				end
			else
				begin
					if (nuser < JumlahUserMax) then
						begin
							daftaruser[nuser+1].name := tmp.name;
							daftaruser[nuser+1].ntebakkata := 0;
							uonline := nuser+1;
							writeln ('Registrasi Berhasil ');
							writeln ('Selamat Datang di Game Hangman');
							writeln ('Tekan Enter untuk menuju ke Menu Utama ');
							nuser := nuser +1;
							savedaftaruser;
						end
					else
						begin
							repeat
								writeln ('Registrasi Gagal, Tidak Ada Tempat Untuk Pengguna Baru');
								writeln ('Silahkan Masukkan Username yang Dikenal'); readln (tmp.name);
								j := 1;
								samename := false;	
								while (j<JumlahUserMax) and (not samename) do
									begin
										if (tmp.name = daftaruser[j].name) then
											begin
											    idx := j;
												samename := true;
											end;
										j := j + 1;		
									end;
								if (samename) then
									begin
									uonline := idx;
									writeln ('Registrasi Berhasil ');
									writeln ('Selamat Datang di Game Hangman');
									writeln ('Tekan Enter untuk menuju ke Menu Utama ');
									end;
							until samename;	
						end;
			end;
		readln();
	end;

(* ####################### Akhir Subprogram Login / Register / Change User ####################### *)

(* ################################## Subprogram Tampilan Menu ################################### *)

(* NIM / Nama : 16511022/Azka Ihsan Nurrahman *)
procedure displaymenu;
{I.S : menu belum ditampilkan }
{F.S : menu sudah ditampilkan }
begin
	clrscr;
	writeln;writeln;
	writeln('###############################################################################');
	writeln('###########################  Program HANGMAN  #################################');
	writeln('###############################################################################');
	writeln('############### Created by : Azka, Bima, Erwin, Kevin, Renand #################');
	writeln('################### Copyright (C) 2011 All Rights Reserved ####################');
	writeln;writeln;
	writeln('Halo ', daftaruser[useronline].name) ;
	writeln('Selamat datang di Program HANGMAN ');
	writeln('Untuk bermain, silahkan ikuti petunjuk di layar ');
	writeln;writeln;
	writeln('Tekan tombol angka untuk memilih menu');
	writeln('Pilihan Menu ');
	writeln('[1] Register / Change User ');
	writeln('[2] Mulai Bermain ');
	writeln('[3] Lihat Skor 10 Pemain Teratas ');
	writeln('[4] Lihat Info ');
	writeln('[5] Menu Bantuan ');
	writeln('[6] Akhiri Permainan ');
	write('Pilihan Anda [1..6] : ');
end;

(* ################################ Akhir Subprogram Tampilan Menu ################################# *)


(* ################################# Subprogram Modus Tebak Kata ################################### *)

{ ************************************* Prosedur Print Hangman ************************************* *}

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h ;
{I.S : Sembarang                 }
{F.S : Menggambar Bagian Hangman }
var
	i : integer ;
begin
	
	writeln ('-----' );
	for	i := 1 to 6 do
	writeln ('|') ;
	
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h1 ;
{I.S : Sembarang                                              }
{F.S : Menggambar Hangman untuk satu kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h2 ;
{I.S : Sembarang                                             }
{F.S : Menggambar Hangman untuk dua kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h3 ;
{I.S : Sembarang                                              }
{F.S : Menggambar Hangman untuk tiga kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|   |') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h4 ;
{I.S : Sembarang                                               }
{F.S : Menggambar Hangman untuk empat kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|  -|') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h5 ;
{I.S : Sembarang                                              }
{F.S : Menggambar Hangman untuk lima kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|  -|-') ;
	writeln ('|') ;
	writeln ('|') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h6 ;
{I.S : Sembarang                                              }
{F.S : Menggambar Hangman untuk enam kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|  -|-') ;
	writeln ('|   |') ;
	writeln ('|') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h7 ;
{I.S : Sembarang                                               }
{F.S : Menggambar Hangman untuk tujuh kesalahan penebakan kata }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|  -|-') ;
	writeln ('|   |') ;
	writeln ('|  /') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure h8 ;
{I.S : Sembarang                                                                           }
{F.S : Menggambar Hangman untuk delapan kesalahan penebakan kata / gambar HANGMAN sempurna }
begin
	writeln ('-----' );
	writeln ('|   |') ;
	writeln ('|   0') ;
	writeln ('|  -|-') ;
	writeln ('|   |') ;
	writeln ('|  / \') ;
	writeln ('|') ;
end ;

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
procedure printhang ( jawabn : string ;  n : integer ) ; //jawabn : status jawaban sementara //n : banyak jawaban yang salah
{ I.S : Sembarang }
{ F.S : Jumlah kesalahan penebakan kata diketahui dan prosedur mengarahkan jumlah tersebut untuk menggambar bagian hangman }
{       dengan menyambungkannya ke prosedur lain                                                                           }
var
	i : integer ; (* Variabel Lokal *)
begin
		clrscr ;
		case n of
			0 : h ;
			1 : h1 ;
			2 : h2 ;
			3 : h3 ;
			4 : h4 ;
			5 : h5 ;
			6 : h6 ;
			7 : h7 ;
			8 : h8 ;
		end;
		for i:= 1 to length(jawabn) do
			write ( jawabn[i], ' ' );
		writeln ();
		
end;

{ *********************************** Fungsi Status Kemenangan Permainan ********************************** *}

(* NIM/Nama : 16511172/Bima Laksmana Pramudita *)
function menang ( jawabn : string ) : boolean ;
(* Fungsi memeriksa apakah semua huruf pada kata sudah ditebak dengan benar. Apabila semua huruf pada kata *)
(* telah ditebak dengan benar, maka fungsi ini mengembalikan nilai boolean berupa true. Jika tidak, maka   *)
(* fungsi ini mengembalikan nilai booelan berupa false                                                     *)
var
	i : integer ; (* Variabel Lokal *)

begin
	menang := true ;
	for i:=1 to length(jawabn) do
		if jawabn[i] = '_' then
			menang := false ;
end;

{ ************************************ Prosedur Permainan Tebak Kata *************************************** }

(* NIM / Nama : 1. 16511172/Bima Laksmana Pramudita *)
(*              2. 16511250/M. Erwin Susetyo        *)
(*              3. 16511100/Renandhitya Fawzian     *)
procedure main ;
{ Pada prosedur permainan ini, jika semua kata sudah ditebak, maka kata tersebut akan dimunculkan kembali ke dalam permainan }
{ I.S : Game tebak kata belum dimainkan }
{ F.S : Game tebak kata telah dimainkan }
var (* Variabel Lokal *)
	katamain : string ; //kata yang di mainkan
	jawaban : string ; //status sementara jawaban pemain
	i,j,k : integer ;  //insialisasi
	hurufsalah : array [1..SalahMax] of char ; //array yg menampung huruf yang salah
	jawab : char ; //character yang dimasukan
	nsalah : integer ; //banyaknya kesalahan yang dilakukan
	barusalah : boolean ; //status ketika huruf yang salah dimasukan pertama kali
	benar : boolean ; // karakter / huruf yang dimasukan benar
	mainterus : boolean ; // status melanjutkan permainan
	terus : string ; // masukkan status melanjutkan permainan
	katabelumditebak : boolean; //apakah kata sudah pernah ditebak sebelumnya?
	tmpnilai : real; //nilaisementara
	
begin
	repeat
		mainterus := true ;
		katabelumditebak := false;
		if daftaruser[useronline].ntebakkata = nkata then
		begin	
			clrscr;
			writeln ('Tidak Ada Kata Untuk Dimainkan');
			mainterus := false;
			readln();
			savedaftaruser;
		end
		else 	
		begin
			repeat 
				randomize;
				katamain := daftarkata[random(nkata)+1] ;
				k := 1;
				while (k<daftaruser[useronline].ntebakkata) and (katamain <> daftaruser[useronline].katatertebak[k]) do
					k := k +1 ;
				if (katamain <> daftaruser[useronline].katatertebak[k]) then
					katabelumditebak := true; 
			until (katabelumditebak);
			jawaban := '';
			for i:= 1 to length(katamain) do
				case katamain[i] of
					' ' : insert(' ',jawaban,length(jawaban)+1) ;
					'-' : insert('-',jawaban,length(jawaban)+1)
				else
					insert('_',jawaban,length(jawaban)+1) ;
				end;
			writeln ( katamain ) ;
			nsalah := 0 ;
			repeat
				printhang (jawaban, nsalah) ;
				readln (jawab) ;
				if(jawab = '#') then
					begin
						nsalah := SalahMax;
					end
				else
					begin
						jawab := upcase(jawab) ;
						benar := false ;
						for i:= 1 to length(katamain) do
						if jawab = katamain[i] then
							begin
								jawaban[i] := jawab ;
								benar := true ;
								writeln('benar ',i) ;
							end;
						if not(benar) then
							begin
								barusalah := true;
								for j := 1 to nsalah do
										if jawab = hurufsalah[j] then
											barusalah := false ;
								if barusalah then
								begin
									nsalah := nsalah + 1 ;
									hurufsalah[nsalah] := jawab ;
									writeln('salah ',nsalah);
								end;
							end;
					end;
			until (menang(jawaban)) or (nsalah >= SalahMax) ;
			printhang (jawaban, nsalah);
			writeln ('Jawaban : ', katamain);	
			tmpnilai := (100 - ( nsalah*nsalah)) ;
			if (daftaruser[useronline].score < tmpnilai) then
				daftaruser[useronline].score := tmpnilai;
			if (daftaruser[useronline].score <= 36) then
				daftaruser[useronline].score := 0;
			daftaruser[useronline].katatertebak[daftaruser[useronline].ntebakkata+1] := katamain;
			daftaruser[useronline].ntebakkata := daftaruser[useronline].ntebakkata+1;	
			writeln ('score anda : ',daftaruser[useronline].score:0:0);
			repeat
				write ('Apakah anda ingin kembali bermain ? ( YES / NO ): ') ;
				readln ( terus ) ;
			until (terus='yes') or (terus='no');
			savedaftaruser;
			terus := upcase(terus) ;
			if (terus = 'NO') then
					mainterus := false;
	end;
	until not(mainterus);
	
end;

(********************************* Prosedur Pembangkitan Daftar Kata ***********************************)

(* NIM / Nama : 16511172/Bima Laksmana Pramudita *)
procedure loaddaftarkata (var dkata : tdaftarkata ; var jumlahkata : integer ) ;
{I.S. : daftar belum terisi ( kosong ) }
{F.S. : daftar sudah terisi }
var
	f : text ;
	i : integer ;
begin
   assign(f, 'daftarkata.txt');	// Menyatakan bahwa f itu variabel untuk file 'daftarkata.txt'
   // Membaca file
   reset(f);	// Mengembalikan kursor ke awal file tanpa menghapusnya, bersiap untuk membaca
   readln(f, jumlahkata);	// Membaca banyaknya kata yang seharusnya dibaca
   for i := 1 to jumlahkata do
      readln(f, dkata[i]);
   close(f);
end;

(* ############################### Akhir Subprogram Modus Tebak Kata ################################# *)

(* ######################################## Subprogram TOPTEN ######################################## *)

(* NIM / Nama : 16511250/M. Erwin Susetyo *)
procedure showtopten;
{F.S. : topten belum terisi}
{I.S. : topten terisi, terurut mulai dari besar ke kecil}
var
	i,pass,imax : integer;
	temp : user;
begin
	clrscr;
	for i:=1 to nuser do
		topten[i] := daftaruser[i];
	for pass:=1 to (nuser-1) do
		begin
			imax := pass;
			for i:=(pass+1) to nuser do
				begin
				if (topten[imax].score < topten[i].score) or ((topten[imax].score = topten[i].score) and (topten[imax].name > topten[i].name)) then
					begin
						temp := topten[imax];
						topten[imax] := topten[i];
						topten[i] := temp;
					end;
				end;
		end;		
	for i:=1 to 10 do
		writeln (topten[i].name ,'-', topten[i].score:0:0);
	writeln ('Tekan enter untuk kembali ke menu utama');
	readln;
	end;

(* ##################################### Akhir Subprogram TOPTEN ##################################### *)

(* #################################### Subprogram Tampilan Info ##################################### *)

(* NIM / Nama : 16511250/M. Erwin Susetyo *)
procedure viewinfo ;
{I.S. : Info tentang user yang sedang online belum ditampilkan}
{F.S. : Info tentang user yang sedang online belum ditampilkan}
begin
	clrscr;
	writeln ('Nama User : ',daftaruser[useronline].name);
	writeln ('Score User : ',daftaruser[useronline].score:0:0);
	writeln ('Tekan enter untuk kembali ke menu utama');
	readln ();
end;

(* ################################# Akhir Subprogram Tampilan Info ################################## *)

(* #################################### Subprogram Menu Bantuan ###################################### *)

(* NIM / Nama : 16511022/Azka Ihsan Nurrahman *)
procedure help ;
{I.S : Menu bantuan belum ditampilkan}
{F.s : Menu bantuan telah ditampilkan}
begin
 clrscr;
 writeln (' \  -----  /  Menu Bantuan ');
 writeln ('   /     \    Silahkan dibaca baik-baik petunjuk di bawah ini ');
 writeln ('  |       |   - Lakukan registrasi atau login terlebih dahulu sebelum mulai ');
 writeln ('  |       |     bermain ');
 writeln ('   \     /    - Setelah login dan registrasi selesai, maka game dapat dimainkan');
 writeln (' /  -----  \  - Aturan penilaian dalam permainan cukup sederhana, yaitu : ');
 writeln ('    |   |     - 1. Skor 100 didapat apabila pemain dapat menebak seluruh kata ');
 writeln ('    |   |          dengan benar tanpa melakukan kesalahan ');
 writeln ('    -----     - 2. Setiap melakukan kesalahan dalam menebak kata, skor pemain ');
 writeln ('                   akan dikurangi ');
 writeln ('    TIPS      - 3. Jika sudah melakukan kesalahan sebanyak 8 kali, maka HANGMAN');
 writeln ('    AND            akan terbentuk dan skor pemain adalah 0 ');
 writeln ('    TRIK      - Pemain dapat mengulang terus permainan sampai mendapatkan skor ');
 writeln ('                tertinggi ');
 writeln ('              Tekan Enter untuk kembali ke Menu Utama ');
 readln;
end;

(* ################################# Akhir Subprogram Menu Bantuan ################################### *)

(* ################################### Algoritma Program Utama ####################################### *)

(* NIM / Nama : 1. 16511172/Bima Laksmana Pramudita *)
(*              2. 16511022/Azka Ihsan Nurrahman    *)
begin
	nuser := 0;
	loaddaftaruser;
	loaddaftarkata ( daftarkata, nkata ) ;
	writeln ('THE HANGMAN ' ) ;
	quit := false;
	login (useronline);
	repeat
		displaymenu ;
		readln ( menu ) ;
		case menu of
			1 : login (useronline) ;
			2 : main ;
			3 : showtopten ;
			4 : viewinfo ;
			5 : help ;
			6 : quit := true
		else
			writeln ('Masukan Angka Salah') ;
			writeln ('Tekan Enter untuk kembali ke Menu Utama ');
			readln();
		end;
	until quit;
	
end.


{ ---------------------------------- Akhir dari keseluruhan program --------------------------------------- }
