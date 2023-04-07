using eCinema.Core;

namespace eCinema.Application
{
    public class ShowProfile : BaseProfile
    {
        public ShowProfile()
        {
            CreateMap<ShowDto, Show>().ReverseMap();

            CreateMap<ShowUpsertDto, Show>();
        }
    }
}
