using eCinema.Core.Entities;
using eCinema.Core;

namespace eCinema.Application.Mapping
{
    public class ReccuringShowProfile : BaseProfile
    {
        public ReccuringShowProfile()
        {
            CreateMap<ReccuringShowDto, ReccuringShows>().ReverseMap();

            CreateMap<ReccuringShowUpsertDto, ReccuringShows>();
        }
    }
}
