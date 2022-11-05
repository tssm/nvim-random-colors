(local {: concat : map : slurp} (require :random-colors.aniseed.core))
(local {: filereadable : fnamemodify : globpath : split : stdpath} vim.fn)

(local state_path (stdpath :state))
(local used_schemes_file (.. state_path "/used_schemes"))

; Create the file that tracks the previously used schemes if it doesn't exists
(when (= 0 (filereadable used_schemes_file))
  (os.execute (.. "mkdir -p " state_path " && touch " used_schemes_file)))

; Sequential table with the names of all the manually installed color schemes
(local all_schemes
  (let
    [path-template :pack/*/%s/*/colors/*.%s
     packpath vim.o.packpath
     paths
      (concat
        (globpath packpath (string.format path-template :opt :lua) false true)
        (globpath packpath (string.format path-template :opt :vim) false true)
        (globpath packpath (string.format path-template :start :lua) false true)
        (globpath packpath (string.format path-template :start :vim) false true))]
    (map (fn [path] (fnamemodify path ":t:r")) paths)))

; Sequential table with the names of all the already used color schemes
(fn used_schemes [] (split (slurp used_schemes_file)))

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
    (vim.api.nvim_exec (.. "colorscheme " scheme) false)
    (os.execute (.. "echo " scheme " >> " used_schemes_file))))
