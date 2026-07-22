class ClssTtlInvstgcns < ApplicationRecord

  def self.clss_dflt
    :indx
  end

  def self.lyt
    {
      indx: {
        clss_str: "pltfrm-titulo-borde rounded-3 p-1 app_lnk responsive-ttl bg-light",
        styl_str: "--rb-font:1.3rem; --rb-lh:1.5; --rb-pad-y:.25rem; --rb-pad-x:.5rem; --rb-border:2px; --rb-font-md:1.1rem; --rb-lh-md:1.4; --rb-pad-y-md:.2rem; --rb-pad-x-md:.4rem; --rb-border-md:2px; --rb-font-sm:.85rem; --rb-lh-sm:1.3; --rb-pad-y-sm:.15rem; --rb-pad-x-sm:.35rem; --rb-border-sm:1px;"
      },
      indx_md: {
        clss_str: "pltfrm-titulo-borde-md rounded-2 app_lnk responsive-ttl bg-light",
        styl_str: "--rb-font:1rem; --rb-lh:1.5; --rb-pad-y:.15rem; --rb-pad-x:.4rem; --rb-border:1px; --rb-font-md:.9rem; --rb-lh-md:1.4; --rb-pad-y-md:.15rem; --rb-pad-x-md:.35rem; --rb-border-md:1px; --rb-font-sm:.75rem; --rb-lh-sm:1.2; --rb-pad-y-sm:.1rem; --rb-pad-x-sm:.3rem; --rb-border-sm:1px;"
      },
      indx_compact: {
        clss_str: "pltfrm-titulo-borde rounded-2 app_lnk responsive-ttl bg-light",
        styl_str: "--rb-font:.9rem; --rb-lh:1.4; --rb-pad-y:.1rem; --rb-pad-x:.35rem; --rb-border:1px; --rb-font-md:.8rem; --rb-lh-md:1.3; --rb-pad-y-md:.1rem; --rb-pad-x-md:.3rem; --rb-border-md:1px; --rb-font-sm:.7rem; --rb-lh-sm:1.1; --rb-pad-y-sm:.05rem; --rb-pad-x-sm:.25rem; --rb-border-sm:1px;"
      },
    }.freeze
  end

end