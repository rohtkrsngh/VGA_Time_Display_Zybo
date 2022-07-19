----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/14/2022 10:51:53 AM
-- Design Name: 
-- Module Name: cdt_movable - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cdt_movable is
 Port (  rst : in std_logic; 
         clk_148 : in std_logic; -- 148 MHz
         R_sw, G_sw, B_sw : in std_logic;       -- color select from switch.
         Data_in1, Data_in2, Data_in3, Data_in4,Data_in5, Data_in6 : in std_logic_vector(3 downto 0);
         status_in7 : in std_logic_vector(1 downto 0);
         button_0, button_1, button_2, button_3 : in std_logic;
         Hsync, Vsync : out std_logic;
         R_out, B_out : out std_logic_vector(4 downto 0);
         G_out : out std_logic_vector(5 downto 0) );
end cdt_movable;

architecture Behavioral of cdt_movable is
signal v_count , h_count : integer:= 0;
signal R, G, B : std_logic := '0'; 
--signal Data_reg : std_logic_vector(7 downto 0);
signal h_end, v_end : std_logic:='0';
signal video_on1, video_on2, video_on3, video_on4, video_on5, video_on6, video_on7, video_on8, video_on9, video_on10, video_on11, video_on12 : std_logic:='0';

--signal count : integer range 0 to 4 := 0;
signal ic,id,it,icn,isp,ist,jc,jd,jt,jcn,jsp,jst,jst_reg: integer :=0;
signal i1, j1, j_reg1 : integer range 0 to 159 :=0;
signal i2, j2, j_reg2 : integer range 0 to 159 :=0;
signal i3, j3, j_reg3 : integer range 0 to 159 :=0;
signal i4, j4, j_reg4 : integer range 0 to 159 :=0;
signal i5, j5, j_reg5 : integer range 0 to 159 :=0;
signal i6, j6, j_reg6 : integer range 0 to 159 :=0;
signal count : integer range 0 to 3 := 0;

signal x1 : integer range 0 to 1920 :=300;
signal y1 : integer range 0 to 1920 :=400;
signal x2: integer range 0 to 1920 :=310;
signal y2 : integer range 0 to 1920 :=416;

signal button_0_reg, button_1_reg, button_2_reg, button_3_reg : std_logic:= '0'; 
signal video_on :std_logic:='0';


type rom_type is array (0 to 271,0 to 9) of std_logic;
   -- ROM definition
   constant ROM: rom_type:=(
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110011100", -- 5 **  ***
   "0110111100", -- 6 ** ****
   "0111101100", -- 7 **** **
   "0111001100", -- 8 ***  **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x31
   "0000000000", -- 0
   "0000000000", -- 1
   "0000110000", -- 2
   "0001110000", -- 3
   "0011110000", -- 4    **
   "0000110000", -- 5   ***
   "0000110000", -- 6  ****
   "0000110000", -- 7    **
   "0000110000", -- 8    **
   "0000110000", -- 9    **
   "0000110000", -- a    **
   "0011111100", -- b    **
   "0000000000", -- c    **
   "0000000000", -- d  ******
   "0000000000", -- e
   "0000000000", -- f
   -- code x32
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0000001100", -- 4      **
   "0000011000", -- 5     **
   "0000110000", -- 6    **
   "0001100000", -- 7   **
   "0011000000", -- 8  **
   "0110000000", -- 9 **
   "0110001100", -- a **   **
   "0111111100", -- b *******
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x33
   "0000000000", -- 0
   "0000000000", -- 1
   "0001111100", -- 2  *****
   "0011000110", -- 3 **   **
   "0000000110", -- 4      **
   "0000000110", -- 5      **
   "0000111100", -- 6   ****
   "0000000110", -- 7      **
   "0000000110", -- 8      **
   "0000000110", -- 9      **
   "0011000110", -- a **   **
   "0001111100", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x34
   "0000000000", -- 0
   "0000000000", -- 1
   "0000011000", -- 2     **
   "0000111000", -- 3    ***
   "0001111000", -- 4   ****
   "0011011000", -- 5  ** **
   "0110011000", -- 6 **  **
   "0111111100", -- 7 *******
   "0000011000", -- 8     **
   "0000011000", -- 9     **
   "0000011000", -- a     **
   "0000111100", -- b    ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x35
   "0000000000", -- 0
   "0000000000", -- 1
   "0111111100", -- 2 *******
   "0110000000", -- 3 **
   "0110000000", -- 4 **
   "0110000000", -- 5 **
   "0111111000", -- 6 ******
   "0000001100", -- 7      **
   "0000001100", -- 8      **
   "0000001100", -- 9      **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x36
   "0000000000", -- 0
   "0000000000", -- 1
   "0001110000", -- 2   ***
   "0011000000", -- 3  **
   "0110000000", -- 4 **
   "0110000000", -- 5 **
   "0111111000", -- 6 ******
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x37
   "0000000000", -- 0
   "0000000000", -- 1
   "0111111100", -- 2 *******
   "0110001100", -- 3 **   **
   "0000001100", -- 4      **
   "0000001100", -- 5      **
   "0000011000", -- 6     **
   "0000110000", -- 7    **
   "0001100000", -- 8   **
   "0001100000", -- 9   **
   "0001100000", -- a   **
   "0001100000", -- b   **
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x38
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0011111000", -- 6  *****
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x39
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0011111100", -- 6  ******
   "0000001100", -- 7      **
   "0000001100", -- 8      **
   "0000001100", -- 9      **
   "0000011000", -- a     **
   "0011110000", -- b  ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   --160
   "0000000000", -- 0
   "0000000000", -- 1
   "0000000000", -- 2
   "0000000000", -- 3
   "0000000000", -- 4
   "0000000000", -- 5
   "0000000000", -- 6
   "0000000000", -- 7
   "0000000000", -- 8
   "0000000000", -- 9
   "0000000000", -- a
   "0000000000", -- b
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   --176
   "0000000000", -- 0
   "0000000000", -- 1
   "0000000000", -- 2
   "0000000000", -- 3
   "0000110000", -- 4    **
   "0000110000", -- 5    **
   "0000000000", -- 6
   "0000000000", -- 7
   "0000000000", -- 8
   "0000110000", -- 9    **
   "0000110000", -- a    **
   "0000000000", -- b
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   --192
   "0000000000", -- 0
   "0000000000", -- 1
   "0001111000", -- 2   ****
   "0011001100", -- 3  **  **
   "0110000100", -- 4 **    *
   "0110000000", -- 5 **
   "0110000000", -- 6 **
   "0110000000", -- 7 **
   "0110000000", -- 8 **
   "0110000100", -- 9 **    *
   "0011001100", -- a  **  **
   "0001111000", -- b   ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- 208
   "0000000000", -- 0
   "0000000000", -- 1
   "0111110000", -- 2 *****
   "0011011000", -- 3  ** **
   "0011001100", -- 4  **  **
   "0011001100", -- 5  **  **
   "0011001100", -- 6  **  **
   "0011001100", -- 7  **  **
   "0011001100", -- 8  **  **
   "0011001100", -- 9  **  **
   "0011011000", -- a  ** **
   "0111110000", -- b *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   
      -- 224
   "0000000000", -- 0
   "0000000000", -- 1
   "0111111110", -- 2 ********
   "0110110110", -- 3 ** ** **
   "0100110010", -- 4 *  **  *
   "0000110000", -- 5    **
   "0000110000", -- 6    **
   "0000110000", -- 7    **
   "0000110000", -- 8    **
   "0000110000", -- 9    **
   "0000110000", -- a    **
   "0001111000", -- b   ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0110001100", -- 2 **   **
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0110001100", -- 6 **   **
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   
    -- 240
   "0000000000", -- 0
   "0000000000", -- 1
   "0110001100", -- 2 **   **
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0111111100", -- 6 *******
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0110001100", -- b **   **
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000" -- f
   ); 
begin
h_end <= '1' when h_count = 2199 else '0';      -- h count end
v_end <= '1' when v_count = 1124 else '0';      -- v count end

process(clk_148, h_end, v_end, v_count)         -- vertical counter
begin
    if rising_edge(clk_148) and h_end = '1' then
        if v_end = '1' then
            v_count <= 0;    
        else 
            v_count <= v_count + 1;
         end if;
     end if;
end process;

process(clk_148, h_end, h_count)            -- horizontal counter
begin
    if rising_edge(clk_148) then
        if h_end = '1' then
           h_count <= 0;
        else   
           h_count <= h_count + 1;
     
            end if ;
         --end if;
     end if;
end process;

Hsync <= '1' when (H_count > 44) else '0';      -- horizontal sync
Vsync <= '1' when (V_count > 5 ) else '0';      -- vertical sync
video_on <= '1' when (H_count >= 132 and H_count < 2052) and (v_count >= 9 and v_count < 1089) else '0';        -- active area select

 process(clk_148,button_0, button_1, button_2, button_3)        -- value assign in regester
 begin
    if rising_edge(clk_148) then  
        button_0_reg <= button_0;
        button_1_reg <= button_1;
        button_2_reg <= button_2;
        button_3_reg <= button_3;
    end if;
 end process;

process(clk_148, video_on, button_0, button_1, button_2, button_3)      -- detect rising edge of signal
 begin
    if rising_edge(clk_148) then    
        if video_on = '1' then 
        
        if button_0 = '1' and button_0_reg = '0' then
            x1 <= x1 + 15;
            x2 <= x2 + 15;
        end if;
        if button_1 = '1' and button_1_reg = '0' then
            x1 <= x1 - 15;
            x2 <= x2 - 15;
        end if;
        if button_2 = '1' and button_2_reg = '0' then
            y1 <= y1 - 15;
            y2 <= y2 - 15;
        end if;
        if button_3 = '1' and button_3_reg = '0' then
            y1 <= y1 + 15;
            y2 <= y2 + 15;
        end if;
     end if;
     end if;
 end process;
 
process(v_count,h_count,ic,id,it,icn,isp,ist,jc,jd,jt,jcn,jsp,jst,i1,i2,i3,i4,i5,i6,j1,j2,j3,j4,j5,j6,x1,x2,y1,y2)    ---- char display and area select
begin  
        if (V_count < y1 and V_count > y2) and (H_count < (x1) and H_count >= (x2+140)) then
             R <= '0';
             G <= '0';
             B <= '0';
        else
        -- C area select 
         if (V_count >= y1 and V_count < y2) and (H_count >= x1 and H_count < x2) then
     
                video_on1 <= '1';
                    if rom(jc,ic) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on1 <= '0';
               
              end if;  
              
                -- D area select 
        if(V_count >= y1 and V_count < y2) and (H_count >= (x1+10) and H_count < (x2+10)) then
     
                video_on2 <= '1';
                    if rom(jd,id) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on2 <= '0';
               
              end if;  
               
                -- T area select 
        if(V_count >= y1 and V_count < y2) and (H_count >= (x1+20) and H_count < (x2+20)) then
     
                video_on3 <= '1';
                    if rom(jt,it) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on3 <= '0';
               
              end if;     
              
                -- : area select 
        if(V_count >= y1 and V_count < y2) and ((H_count >= (x1+30) and H_count < (x2+30)) or (H_count >= (x1+70) and H_count < (x2+70))or (H_count >= (x1+100) and H_count < (x2+100))or (H_count >= (x1+130) and H_count < (x2+130)) )then
     
                video_on4 <= '1';
                    if rom(jcn,icn) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on4 <= '0';
               
              end if;  
              
                -- space area select 
        if(V_count >= y1 and V_count < y2) and (H_count >= (x1+40) and H_count < (x2+40)) then
     
                video_on5 <= '1';
                    if rom(jsp,isp) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on5 <= '0';
               
              end if;     
           
           -- 1st area select              
        if(V_count >= y1 and V_count < y2) and (H_count >= (x1+50) and H_count < (x2+50)) then
     
                video_on6 <= '1';
                    if rom(j1,i1) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on6 <= '0';
               
              end if;
           -- 2nd area select 
           if(V_count >= y1 and V_count < y2) and (H_count >= (x1+60) and H_count < (x2+60)) then
     
                video_on7 <= '1';
                    if rom(j2,i2) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
                else
                video_on7 <= '0';
                
              end if;

           -- 3rd area select 
           if(V_count >= y1 and V_count < y2) and (H_count >= (x1+80) and H_count < (x2+80)) then
     
                video_on8 <= '1';
                    if rom(j3,i3) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
                else
                video_on8 <= '0';
                
                end if;
              -- 4th area select 
              if(V_count >= y1 and V_count < y2) and (H_count >= (x1+90) and H_count < (x2+90)) then
     
                video_on9 <= '1';
                    if rom(j4,i4) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
                else
                video_on9 <= '0';
               end if; 

                 -- 5th area select              
        if(V_count >= y1 and V_count < y2) and (H_count >= (x1+110) and H_count < (x2+110)) then
     
                video_on10 <= '1';
                    if rom(j5,i5) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
              else
                video_on10 <= '0';
               
              end if;
           -- 6th area select 
           if(V_count >= y1 and V_count < y2) and (H_count >= (x1+120) and H_count < (x2+120)) then
     
                video_on11 <= '1';
                    if rom(j6,i6) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
                else
                video_on11 <= '0';
                
              end if;

                
           -- 7th area select 
           if(V_count >= y1 and V_count < y2) and (H_count >= (x1+140) and H_count < (x2+140)) then
     
                video_on12 <= '1';
                    if rom(jst,ist) = '1' then
                        R <= R_sw;
                        G <= G_sw;
                        B <= B_sw;
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                    end if;
                else
                video_on12 <= '0';
                
                end if;
        end if;
  end process;
  
  ---input h1 
  process(Data_in1)
  begin
    case(Data_in1) is
        when "0000" =>  j_reg1 <= 0;
        when "0001" =>  j_reg1 <= 16;
        when "0010" =>  j_reg1 <= 32;
        when "0011" =>  j_reg1 <= 48;
        when "0100" =>  j_reg1 <= 64;
        when "0101" =>  j_reg1 <= 80;
        when "0110" =>  j_reg1 <= 96;
        when "0111" =>  j_reg1 <= 112;
        when "1000" =>  j_reg1 <= 128;
        when "1001" =>  j_reg1 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in2)
  begin
    case(Data_in2) is
        when "0000" =>  j_reg2 <= 0;
        when "0001" =>  j_reg2 <= 16;
        when "0010" =>  j_reg2 <= 32;
        when "0011" =>  j_reg2 <= 48;
        when "0100" =>  j_reg2 <= 64;
        when "0101" =>  j_reg2 <= 80;
        when "0110" =>  j_reg2 <= 96;
        when "0111" =>  j_reg2 <= 112;
        when "1000" =>  j_reg2 <= 128;
        when "1001" =>  j_reg2 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in3)
  begin
    case(Data_in3) is
        when "0000" =>  j_reg3 <= 0;
        when "0001" =>  j_reg3 <= 16;
        when "0010" =>  j_reg3 <= 32;
        when "0011" =>  j_reg3 <= 48;
        when "0100" =>  j_reg3 <= 64;
        when "0101" =>  j_reg3 <= 80;
        when "0110" =>  j_reg3 <= 96;
        when "0111" =>  j_reg3 <= 112;
        when "1000" =>  j_reg3 <= 128;
        when "1001" =>  j_reg3 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in4)
  begin
    case(Data_in4) is
        when "0000" =>  j_reg4 <= 0;
        when "0001" =>  j_reg4 <= 16;
        when "0010" =>  j_reg4 <= 32;
        when "0011" =>  j_reg4 <= 48;
        when "0100" =>  j_reg4 <= 64;
        when "0101" =>  j_reg4 <= 80;
        when "0110" =>  j_reg4 <= 96;
        when "0111" =>  j_reg4 <= 112;
        when "1000" =>  j_reg4 <= 128;
        when "1001" =>  j_reg4 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in5)
  begin
    case(Data_in5) is
        when "0000" =>  j_reg5 <= 0;
        when "0001" =>  j_reg5 <= 16;
        when "0010" =>  j_reg5 <= 32;
        when "0011" =>  j_reg5 <= 48;
        when "0100" =>  j_reg5 <= 64;
        when "0101" =>  j_reg5 <= 80;
        when "0110" =>  j_reg5 <= 96;
        when "0111" =>  j_reg5 <= 112;
        when "1000" =>  j_reg5 <= 128;
        when "1001" =>  j_reg5 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in6)
  begin
    case(Data_in6) is
        when "0000" =>  j_reg6 <= 0;
        when "0001" =>  j_reg6 <= 16;
        when "0010" =>  j_reg6 <= 32;
        when "0011" =>  j_reg6 <= 48;
        when "0100" =>  j_reg6 <= 64;
        when "0101" =>  j_reg6 <= 80;
        when "0110" =>  j_reg6 <= 96;
        when "0111" =>  j_reg6 <= 112;
        when "1000" =>  j_reg6 <= 128;
        when "1001" =>  j_reg6 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(status_in7)
  begin
    case(status_in7) is
        when "00" =>  jst_reg <= 208;  --D
        when "01" =>  jst_reg <= 240;  --U
        when "10" =>  jst_reg <= 256;  --H
        when others =>  null;
        
    end case;
  end process;

 ---C pixel counter
 process(clk_148,ic,jc)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            jc <= 192;
        end if;
        if video_on1 = '1' then
            if jc = jc+ 15 then
                     jc <= 192;
                  --   i <= 0;
            elsif ic = 9 then
                    jc <= jc+1;
                    ic<= 0;
               else
                    ic<= ic+1;
                end if;
            --   end if;
           else
                ic <= 0;
           end if;
          end if;
   end process;
    
 
  ---D pixel counter
 process(clk_148,id,jd)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            jd <= 208;
        end if;
        if video_on2 = '1' then
            if jd = jd+ 15 then
                     jd <= 208;
                  --   i <= 0;
            elsif id = 9 then
                    jd <= jd+1;
                    id<= 0;
               else
                    id<= id+1;
                end if;
            --   end if;
           else
                id <= 0;
           end if;
          end if;
   end process;
   
    ---T pixel counter
 process(clk_148,it,jt)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            jt <= 224;
        end if;
        if video_on3 = '1' then
            if jt = jt+ 15 then
                     jt <= 224;
                  --   i <= 0;
            elsif it = 9 then
                    jt <= jt+1;
                    it<= 0;
               else
                    it<= it+1;
                end if;
            --   end if;
           else
                it <= 0;
           end if;
          end if;
   end process;
  
   ---":" pixel counter
 process(clk_148,icn,jcn)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            jcn <= 176;
        end if;
        if video_on4 = '1' then
            if jcn = jcn+ 15 then
                     jcn <= 176;
                  --   i <= 0;
            elsif icn = 9 then
                icn<= 0;
                if count = 3 then
                    jcn <= jcn+1;
                    count <= 0;
                else
                    count <= count + 1;
                end if;
                    
               else
                    icn<= icn+1;
                end if;
            --   end if;
           else
                icn <= 0;
           end if;
          end if;
   end process;  
   
    ---" " pixel counter
 process(clk_148,isp,jsp)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            jsp <= 160;
        end if;
        if video_on1 = '1' then
            if jsp = jsp+ 15 then
                     jsp <= 160;
                  --   i <= 0;
            elsif isp = 9 then
                    jsp <= jsp+1;
                    isp<= 0;
               else
                    isp<= isp+1;
                end if;
            --   end if;
           else
                isp <= 0;
           end if;
          end if;
   end process;
   
  --- pixel counter
 process(clk_148,i1,j1)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            j1 <= j_reg1;
        end if;
        if video_on6 = '1' then
            if j1 = j_reg1 + 15 then
                     j1 <= j_reg1;
                  --   i <= 0;
            elsif i1 = 9 then
                    j1 <= j1+1;
                    i1<= 0;
               else
                    i1<= i1+1;
                end if;
            --   end if;
           else
                i1 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i2,j2)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            j2 <= j_reg2;
        end if;
        if video_on7 = '1' then
            if j2 = j_reg2 + 15 then
                     j2 <= j_reg2;
                  --   i <= 0;
            elsif i2 = 9 then
                    j2 <= j2+1;
                    i2<= 0;
               else
                    i2<= i2+1;
                end if;
            --   end if;
           else
                i2 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i3,j3)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            j3 <= j_reg3;
        end if;
        if video_on8 = '1' then
            if j3 = j_reg3 + 15 then
                     j3 <= j_reg3;
                  --   i <= 0;
            elsif i3 = 9 then
                    j3 <= j3+1;
                    i3<= 0;
               else
                    i3<= i3+1;
                end if;
            --   end if;
           else
                i3 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i4,j4)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            j4 <= j_reg4;
        end if;
        if video_on9 = '1' then
            if j4 = j_reg4 + 15 then
                     j4 <= j_reg4;
                  --   i <= 0;
            elsif i4 = 9 then
                    j4 <= j4+1;
                    i4<= 0;
               else
                    i4<= i4+1;
                end if;
            --   end if;
           else
                i4 <= 0;
           end if;
          end if;
   end process;
   
       --- pixel counter
 process(clk_148,i5,j5)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            j5 <= j_reg5;
        end if;
        if video_on10 = '1' then
            if j5 = j_reg5 + 15 then
                     j5 <= j_reg5;
                  --   i <= 0;
            elsif i5 = 9 then
                    j5 <= j5+1;
                    i5<= 0;
               else
                    i5<= i5+1;
                end if;
            --   end if;
           else
                i5 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i6,j6)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            j6 <= j_reg6;
        end if;
        if video_on11 = '1' then
            if j6 = j_reg6 + 15 then
                     j6 <= j_reg6;
                  --   i <= 0;
            elsif i6 = 9 then
                    j6 <= j6+1;
                    i6<= 0;
               else
                    i6<= i6+1;
                end if;
            --   end if;
           else
                i6 <= 0;
           end if;
          end if;
   end process;
   
       --- pixel counter
 process(clk_148,ist,jst)
   begin
    if rising_edge(clk_148) then
        if V_count = 9 and H_count = 132 then
            jst <= jst_reg;
        end if;
        if video_on12 = '1' then
            if jst = jst_reg + 15 then
                     jst <= jst_reg;
                  --   i <= 0;
            elsif ist = 9 then
                    jst <= jst+1;
                    ist<= 0;
               else
                    ist<= ist+1;
                end if;
            --   end if;
           else
                ist <= 0;
           end if;
          end if;
   end process;
   
   
    
R_out <= "11111" when ( R = '1' ) else "00000";
G_out <= "111111" when ( G = '1') else "000000";
B_out <= "11111" when ( B = '1' ) else "00000";


end Behavioral;
