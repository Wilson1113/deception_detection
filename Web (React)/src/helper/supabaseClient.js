import { createClient } from "@supabase/supabase-js";

const supabaseUrl = "https://itzrbjmaxwzplkseloor.supabase.co"
const supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0enJiam1heHd6cGxrc2Vsb29yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyOTM1NTcsImV4cCI6MjA2Mjg2OTU1N30.yxRoSA-u3_EmAzlI2c7KyK0UTag_msQnm3SC2fsEpeA"

const supabase = createClient(supabaseUrl, supabaseAnonKey);
export default supabase;