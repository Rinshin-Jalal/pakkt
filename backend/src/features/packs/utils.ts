/**
 * Generate a random invite code
 */
export function generateInviteCode(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Exclude ambiguous chars
  let code = '';
  for (let i = 0; i < 8; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}

/**
 * Calculate pack level from total XP
 * Level formula: level_n requires level_(n-1) + n * 100
 * Level 1: 0 XP
 * Level 2: 100 XP
 * Level 3: 300 XP (100 + 200)
 * Level 4: 600 XP (300 + 300)
 */
export function calculateLevelFromXP(xp: number): number {
  if (xp < 0) return 1;
  
  let level = 1;
  let xpRequired = 0;
  
  while (xpRequired <= xp) {
    level++;
    xpRequired += level * 100;
  }
  
  return level - 1;
}

/**
 * Calculate XP required for next level
 */
export function getXPForNextLevel(currentLevel: number): number {
  return (currentLevel + 1) * 100;
}

/**
 * Calculate XP progress to next level
 */
export function getXPProgress(totalXP: number): {
  currentLevel: number;
  currentLevelXP: number;
  nextLevelXP: number;
  progress: number;
} {
  const currentLevel = calculateLevelFromXP(totalXP);
  
  // Calculate XP at start of current level
  let xpAtLevelStart = 0;
  for (let i = 1; i < currentLevel; i++) {
    xpAtLevelStart += i * 100;
  }
  
  const currentLevelXP = totalXP - xpAtLevelStart;
  const nextLevelXP = (currentLevel + 1) * 100;
  const progress = (currentLevelXP / nextLevelXP) * 100;
  
  return {
    currentLevel,
    currentLevelXP,
    nextLevelXP,
    progress: Math.min(100, Math.max(0, progress)),
  };
}

/**
 * Validate member count is within limits (3-10)
 */
export function validateMemberLimit(currentCount: number, adding: number = 1): boolean {
  const newCount = currentCount + adding;
  return newCount >= 3 && newCount <= 10;
}

/**
 * Check if pack can be dissolved (no active fines)
 */
export async function canDissolvePack(
  supabase: any,
  packId: string
): Promise<{ canDissolve: boolean; reason?: string }> {
  // Check for active fines
  const { data: activeFines, error } = await supabase
    .from('fines')
    .select('id')
    .eq('pack_id', packId)
    .in('status', ['pending', 'active'])
    .limit(1);

  if (error) {
    return { canDissolve: false, reason: 'Failed to check active fines' };
  }

  if (activeFines && activeFines.length > 0) {
    return { canDissolve: false, reason: 'Cannot dissolve pack with active fines' };
  }

  return { canDissolve: true };
}
