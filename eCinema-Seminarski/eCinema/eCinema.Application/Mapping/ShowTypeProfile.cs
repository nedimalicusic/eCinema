using eCinema.Core.Entities;
using eCinema.Core;

namespace eCinema.Application.Mapping
{
    public class ShowTypeProfile : BaseProfile
    {
        public ShowTypeProfile()
        {
            CreateMap<ShowTypeDto, ShowType>().ReverseMap();

            CreateMap<ShowTypeUpsertDto, ShowType>();
        }
    }
}
