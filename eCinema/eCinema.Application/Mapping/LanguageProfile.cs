using eCinema.Core;

namespace eCinema.Application
{
    public class LanguageProfile : BaseProfile
    {
        public LanguageProfile()
        {
            CreateMap<LanguageDto, Language>().ReverseMap();

            CreateMap<LanguageUpsertDto, Language>();
        }
    }
}
