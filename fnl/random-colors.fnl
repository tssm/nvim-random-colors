(local api vim.api)
(local core (require :random-colors.aniseed.core))
(local f vim.fn)

(local state_path (f.stdpath :state))
(local used_schemes_file (.. state_path "/used_schemes"))

; Create the file that tracks the previously used schemes if it doesn't exists
(when (= 0 (f.filereadable used_schemes_file))
  (os.execute (.. "mkdir -p " state_path " && touch " used_schemes_file)))

; Sequential table with the names of all the manually installed color schemes
(local all_schemes
  (let
    [strings
      (f.globpath (api.nvim_get_option :packpath) "pack/**/colors/*.vim")
     paths (f.split strings "\n")]
    (core.map (fn [path] (f.fnamemodify path ":t:r")) paths)))

; Sequential table with the names of all the already used color schemes
(fn used_schemes [] (f.split (core.slurp used_schemes_file)))

(fn \\ [a b]
  (let [remove {} result {}]
    (each [_ v (ipairs b)] (tset remove v true))
    (each [_ v (ipairs a)] (when (not (. remove v)) (table.insert result v)))
    result))

; Random number based on when the user opens the editor
(fn random_number [limit] (+ (% (os.time) limit) 1))

; Sequential table with the names of all not-yet-used schemes
(fn available_schemes []
  (let [difference (\\ all_schemes (used_schemes))]
    (if
      (= 0 (length difference)) all_schemes
      difference)))

(fn set_scheme []
  (let
    [total_schemes (length (available_schemes))
     schemes (available_schemes)
     scheme (. schemes (random_number total_schemes))]
    (when (= total_schemes (length all_schemes))
      (os.execute (.. "echo '' > " used_schemes_file)))
    (api.nvim_command (.. "colorscheme " scheme))
    (os.execute (.. "echo " scheme " >> " used_schemes_file))))
