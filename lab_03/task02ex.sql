SELECT firstName, lastName, birthDate, game_cnt 
from list_of_experts(500) loe
join player_info pi
on pi.player_id = loe.player_id
order by game_cnt desc;
